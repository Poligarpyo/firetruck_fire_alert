import 'package:firebase_database/firebase_database.dart';

import '../../domain/entities/firetruck_status.dart';
import '../models/firetruck_location_model.dart';

abstract class FiretruckLocationRemoteSource {
  /// Pushes a single GPS sample. Bandwidth-optimized:
  ///  * uses `ServerValue.timestamp` (no client clock skew)
  ///  * writes only changed fields (callers should pre-filter)
  ///  * single multi-path update -> one network round-trip
  Future<void> updateLocation({
    required String truckId,
    required double latitude,
    required double longitude,
    double? heading,
    double? speed,
    double? accuracy,
  });

  /// Sets the truck's operational status without rewriting the location.
  Future<void> setStatus({
    required String truckId,
    required FiretruckStatus status,
  });

  /// Watches a single truck's full node. Emits `null` when no data exists
  /// yet (e.g. before the first write) instead of throwing — UI can show an
  /// "offline" placeholder.
  Stream<FiretruckLocationModel?> watchTruck(String truckId);

  /// Watches *all* trucks at once. Useful for the dispatcher's fleet map.
  /// Emits a list (possibly empty); never throws on missing data.
  Stream<List<FiretruckLocationModel>> watchFleet();

  /// Registers `onDisconnect` handlers so the truck flips to `offline`
  /// when the socket dies, and immediately marks itself online.
  ///
  /// Call once per session, after sign-in. Safe to call again — it overwrites
  /// the previous registration on the same connection.
  Future<void> setupPresence({
    required String truckId,
    FiretruckStatus initialStatus = FiretruckStatus.available,
  });
}

class FiretruckLocationRemoteSourceImpl
    implements FiretruckLocationRemoteSource {
  final FirebaseDatabase _db;

  FiretruckLocationRemoteSourceImpl({FirebaseDatabase? db})
    : _db = db ?? FirebaseDatabase.instance;

  DatabaseReference _truckRef(String id) => _db.ref('firetrucks/$id');

  @override
  Future<void> updateLocation({
    required String truckId,
    required double latitude,
    required double longitude,
    double? heading,
    double? speed,
    double? accuracy,
  }) {
    final base = 'firetrucks/$truckId';
    final updates = <String, Object?>{
      '$base/location/lat': latitude,
      '$base/location/lng': longitude,
      '$base/location/updatedAt': ServerValue.timestamp,
      '$base/lastSeen': ServerValue.timestamp,
      if (heading != null) '$base/location/heading': heading,
      if (speed != null) '$base/location/speed': speed,
      if (accuracy != null) '$base/location/accuracy': accuracy,
    };
    return _db.ref().update(updates);
  }

  @override
  Future<void> setStatus({
    required String truckId,
    required FiretruckStatus status,
  }) {
    return _db.ref().update({
      'firetrucks/$truckId/status': status.wireValue,
      'firetrucks/$truckId/lastSeen': ServerValue.timestamp,
    });
  }

  @override
  Stream<FiretruckLocationModel?> watchTruck(String truckId) {
    return _truckRef(truckId).onValue.map((event) {
      final raw = event.snapshot.value;
      if (raw is! Map) return null;
      return FiretruckLocationModel.fromTruckNode(truckId, raw);
    });
  }

  @override
  Stream<List<FiretruckLocationModel>> watchFleet() {
    return _db.ref('firetrucks').onValue.map((event) {
      final raw = event.snapshot.value;
      if (raw is! Map) return const <FiretruckLocationModel>[];

      final trucks = <FiretruckLocationModel>[];
      raw.forEach((key, value) {
        if (key is! String || value is! Map) return;
        trucks.add(FiretruckLocationModel.fromTruckNode(key, value));
      });
      return trucks;
    });
  }

  @override
  Future<void> setupPresence({
    required String truckId,
    FiretruckStatus initialStatus = FiretruckStatus.available,
  }) async {
    final ref = _truckRef(truckId);

    // Tear down any previous handlers on this connection before re-registering
    // so we don't queue duplicate offline writes.
    await ref.child('status').onDisconnect().cancel();
    await ref.child('lastSeen').onDisconnect().cancel();

    // When the realtime socket drops, the server stamps these for us.
    await ref.child('status').onDisconnect().set(FiretruckStatus.offline.wireValue);
    await ref.child('lastSeen').onDisconnect().set(ServerValue.timestamp);

    // Mark ourselves online right now.
    await _db.ref().update({
      'firetrucks/$truckId/status': initialStatus.wireValue,
      'firetrucks/$truckId/lastSeen': ServerValue.timestamp,
    });
  }
}
