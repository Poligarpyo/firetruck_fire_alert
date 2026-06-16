import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../../domain/entities/firetruck_status.dart';
import '../../domain/usecases/set_truck_status_usecase.dart';
import '../../domain/usecases/setup_truck_presence_usecase.dart';
import '../../domain/usecases/update_firetruck_location_usecase.dart';

/// Tunable filters applied before every RTDB write.
///
/// Defaults are tuned for a moving firetruck:
///  * fire on every 5 m of travel
///  * never write more than once every 2 seconds
///  * drop samples worse than 50 m horizontal accuracy (urban canyon noise)
///  * always write at least every 30 s as a heartbeat (so the dispatcher
///    sees `lastSeen` tick even when stationary)
class LocationPublisherConfig {
  final double minDistanceMeters;
  final Duration minInterval;
  final Duration heartbeatInterval;
  final double maxAcceptableAccuracyMeters;
  final LocationAccuracy accuracy;

  const LocationPublisherConfig({
    this.minDistanceMeters = 5.0,
    this.minInterval = const Duration(seconds: 2),
    this.heartbeatInterval = const Duration(seconds: 30),
    this.maxAcceptableAccuracyMeters = 50.0,
    this.accuracy = LocationAccuracy.high,
  });
}

/// Owns the GPS subscription on the truck device and publishes filtered
/// samples to Firebase Realtime Database via [UpdateFiretruckLocationUseCase].
///
/// Designed so the UI never touches Firebase directly — the publisher is the
/// single writer for the truck's node. Lifecycle is `start(truckId)` →
/// `stop()`. Safe to call `start` multiple times; later calls swap truckIds.
class FiretruckLocationPublisher {
  final UpdateFiretruckLocationUseCase _update;
  final SetupTruckPresenceUseCase _presence;
  final SetTruckStatusUseCase _setStatus;
  final LocationPublisherConfig _config;

  StreamSubscription<Position>? _gpsSub;
  Timer? _heartbeatTimer;

  String? _truckId;
  Position? _lastWritten;
  DateTime _lastWriteAt = DateTime.fromMillisecondsSinceEpoch(0);
  bool _writeInFlight = false;

  /// Mirror of the latest desired status so a reconnect resync can
  /// re-arm `onDisconnect` with the correct value (otherwise we'd flip
  /// a busy truck back to `available` even mid-incident).
  FiretruckStatus _currentStatus = FiretruckStatus.offline;

  FiretruckLocationPublisher({
    required UpdateFiretruckLocationUseCase update,
    required SetupTruckPresenceUseCase presence,
    required SetTruckStatusUseCase setStatus,
    LocationPublisherConfig config = const LocationPublisherConfig(),
  }) : _update = update,
       _presence = presence,
       _setStatus = setStatus,
       _config = config;

  bool get isPublishing => _gpsSub != null;
  String? get currentTruckId => _truckId;

  /// Begins publishing for [truckId].
  ///
  /// Pass [initialStatus] to control whether the truck appears as `available`
  /// (idle on station) or `enroute` (already on a dispatch).
  Future<void> start(
    String truckId, {
    FiretruckStatus initialStatus = FiretruckStatus.available,
  }) async {
    if (_truckId == truckId && _gpsSub != null) return;

    if (_truckId != null && _truckId != truckId) {
      await stop();
    }

    _truckId = truckId;
    _currentStatus = initialStatus;

    final granted = await _ensureLocationPermission();
    if (!granted) {
      throw const PermissionDeniedException('Location permission denied');
    }

    debugPrint('[FiretruckLocationPublisher] start truckId=$truckId');
    await _presence.call(truckId: truckId, initialStatus: initialStatus);

    _gpsSub =
        Geolocator.getPositionStream(
          locationSettings: LocationSettings(
            accuracy: _config.accuracy,
            // Native-side coarse filter; we still apply our own distance gate
            // below to dodge GPS jitter under canopy.
            distanceFilter: _config.minDistanceMeters.round(),
          ),
        ).listen(
          _onPosition,
          onError: (Object e, StackTrace s) {
            debugPrint('[FiretruckLocationPublisher] GPS error: $e');
          },
          cancelOnError: false,
        );

    _heartbeatTimer = Timer.periodic(_config.heartbeatInterval, (_) {
      _emitHeartbeat();
    });
  }

  /// Updates the truck's status (e.g. when the driver accepts a dispatch).
  Future<void> setStatus(FiretruckStatus status) async {
    final id = _truckId;
    if (id == null) return;
    _currentStatus = status;
    await _setStatus.call(truckId: id, status: status);
  }

  /// Stops the GPS subscription and flips the truck offline.
  Future<void> stop() async {
    final id = _truckId;
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    await _gpsSub?.cancel();
    _gpsSub = null;
    _lastWritten = null;
    _lastWriteAt = DateTime.fromMillisecondsSinceEpoch(0);
    _truckId = null;
    _currentStatus = FiretruckStatus.offline;

    if (id != null) {
      try {
        await _setStatus.call(truckId: id, status: FiretruckStatus.offline);
      } catch (e) {
        // Non-fatal — `onDisconnect` will fire offline status anyway.
        debugPrint('[FiretruckLocationPublisher] stop() setStatus failed: $e');
      }
    }
  }

  /// Forces a re-sync after the device regains internet connectivity.
  ///
  /// Three things must happen on reconnect or the dispatcher will see a
  /// stale truck:
  ///   1. The previous `onDisconnect` handler already fired `offline` on
  ///      the server when the socket dropped, so we re-arm presence and
  ///      re-apply the truck's current status (`available` / `enroute`).
  ///   2. Any write that was in flight when the socket died may still be
  ///      sitting in the SDK's queue with `_writeInFlight = true` from
  ///      our perspective — clear that flag so the next sample can go.
  ///   3. Re-emit the last known position immediately (bypassing the
  ///      throttle) so `lastSeen` and lat/lng refresh without waiting
  ///      up to 30s for the next heartbeat tick.
  Future<void> resyncAfterReconnect() async {
    final id = _truckId;
    if (id == null) return;

    debugPrint(
      '[FiretruckLocationPublisher] resync after reconnect '
      'truckId=$id status=${_currentStatus.wireValue}',
    );

    // Unblock the writer in case the prior write is still pending in the
    // Firebase queue from our perspective.
    _writeInFlight = false;

    try {
      await _presence.call(truckId: id, initialStatus: _currentStatus);
    } catch (e) {
      debugPrint('[FiretruckLocationPublisher] resync presence failed: $e');
    }

    final last = _lastWritten;
    if (last != null) {
      // Reset the throttle so the immediate re-emit goes through.
      _lastWriteAt = DateTime.fromMillisecondsSinceEpoch(0);
      await _writePosition(last);
    }
  }

  // ── Internal ──────────────────────────────────────────────────────────────

  void _onPosition(Position p) {
    if (!_shouldWrite(p)) return;
    unawaited(_writePosition(p));
  }

  bool _shouldWrite(Position p) {
    if (p.accuracy > _config.maxAcceptableAccuracyMeters) return false;

    final now = DateTime.now();
    if (now.difference(_lastWriteAt) < _config.minInterval) return false;

    final last = _lastWritten;
    if (last != null) {
      final moved = Geolocator.distanceBetween(
        last.latitude,
        last.longitude,
        p.latitude,
        p.longitude,
      );
      if (moved < _config.minDistanceMeters) return false;
    }
    return true;
  }

  /// How long we wait for a single Firebase write before assuming the
  /// device is offline and freeing up the publisher for the next sample.
  /// The Firebase SDK keeps the write queued internally and will flush
  /// it once connectivity returns.
  static const Duration _writeTimeout = Duration(seconds: 8);

  Future<void> _writePosition(Position p) async {
    final id = _truckId;
    if (id == null) return;
    if (_writeInFlight) return;
    _writeInFlight = true;
    try {
      await _update
          .call(
            truckId: id,
            latitude: p.latitude,
            longitude: p.longitude,
            heading: p.heading.isFinite && p.heading >= 0 ? p.heading : null,
            speed: p.speed.isFinite && p.speed >= 0 ? p.speed : null,
            accuracy: p.accuracy.isFinite ? p.accuracy : null,
          )
          .timeout(_writeTimeout);
      _lastWritten = p;
      _lastWriteAt = DateTime.now();
      debugPrint(
        '[FiretruckLocationPublisher] wrote $id -> '
        '(${p.latitude.toStringAsFixed(5)}, ${p.longitude.toStringAsFixed(5)}) '
        'acc=${p.accuracy.toStringAsFixed(1)}m',
      );
    } on TimeoutException {
      // Almost certainly offline — Firebase will hold the write in its
      // own queue and flush it on reconnect. Optimistically remember the
      // sample so `resyncAfterReconnect` can re-emit it without waiting
      // for the next GPS tick.
      _lastWritten = p;
      debugPrint(
        '[FiretruckLocationPublisher] write timed out (offline?) — '
        'will retry on reconnect',
      );
    } catch (e) {
      debugPrint('[FiretruckLocationPublisher] write failed: $e');
    } finally {
      _writeInFlight = false;
    }
  }

  /// Re-pushes the last known position so the dispatcher's "lastSeen" stays
  /// fresh while the truck is parked. No-op until we have a fix.
  void _emitHeartbeat() {
    final last = _lastWritten;
    final id = _truckId;
    if (last == null || id == null) return;
    if (DateTime.now().difference(_lastWriteAt) < _config.heartbeatInterval) {
      return;
    }
    unawaited(_writePosition(last));
  }

  Future<bool> _ensureLocationPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) return false;

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    return perm == LocationPermission.always ||
        perm == LocationPermission.whileInUse;
  }
}

class PermissionDeniedException implements Exception {
  final String message;
  const PermissionDeniedException(this.message);

  @override
  String toString() => 'PermissionDeniedException: $message';
}
