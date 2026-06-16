import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../data/services/firetruck_location_publisher.dart';
import '../../domain/constants/destination_arrival_radius.dart';
import '../../domain/entities/firetruck_status.dart';
import '../providers/assignment_provider.dart';
import '../providers/firetruck_location_providers.dart';

/// Mounts somewhere stable in the widget tree (typically the GPS screen)
/// and owns the lifecycle of [FiretruckLocationPublisher].
///
/// Behavior:
///  * Starts publishing as soon as we know the driver's truck id, even if
///    no incident is assigned yet — so dispatchers see the truck as
///    `available` on the fleet map immediately after login.
///  * Switches the truck's RTDB status to `enroute` while an incident is
///    assigned, to `on-scene` once on scene (`arrived_at` / geofence), and
///    back to `available` when the incident clears.
///  * Stops publishing on dispose (logout / leaving the GPS screen).
class LocationPublishingGate extends ConsumerStatefulWidget {
  const LocationPublishingGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<LocationPublishingGate> createState() =>
      _LocationPublishingGateState();
}

class _LocationPublishingGateState
    extends ConsumerState<LocationPublishingGate> {
  String? _activeTruckId;
  FiretruckStatus _activeStatus = FiretruckStatus.offline;
  final Set<String> _arrivedMarkedIncidents = <String>{};
  final Set<String> _arrivedWriteInFlight = <String>{};

  /// Cached while [build] runs so [dispose] can call [FiretruckLocationPublisher.stop]
  /// without using [ref] (unsafe after unmount).
  FiretruckLocationPublisher? _locationPublisher;

  @override
  void initState() {
    super.initState();
    // Kick off an initial sync once the first frame is rendered. After that
    // the `ref.listen` calls in build() drive any further updates.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _resync();
    });
  }

  @override
  void dispose() {
    final publisher = _locationPublisher;
    if (publisher != null) {
      unawaited(publisher.stop());
    }
    super.dispose();
  }

  void _resync() {
    final truckId = ref.read(myAssignedTruckIdProvider).value;
    final assignment = ref.read(firetruckAssignmentRealtimeProvider).value;
    final hasIncident = assignment != null;

    final FiretruckStatus desired;
    if (!hasIncident) {
      desired = FiretruckStatus.available;
    } else {
      final arrived =
          _toDateTime(assignment.incidentData['arrived_at']) ??
          _toDateTime(assignment.incidentData['arrivedAt']);
      desired = arrived != null
          ? FiretruckStatus.onsite
          : FiretruckStatus.enroute;
    }
    unawaited(_syncPublisher(truckId, desired));
  }

  Future<void> _syncPublisher(String? truckId, FiretruckStatus status) async {
    final publisher = ref.read(firetruckLocationPublisherProvider);

    if (truckId == null) {
      if (_activeTruckId != null) {
        debugPrint('[LocationPublishingGate] no truck — stopping publisher');
        _activeTruckId = null;
        _activeStatus = FiretruckStatus.offline;
        await publisher.stop();
      }
      return;
    }

    if (_activeTruckId != truckId) {
      debugPrint(
        '[LocationPublishingGate] starting publisher truckId=$truckId '
        'status=${status.wireValue}',
      );
      _activeTruckId = truckId;
      _activeStatus = status;
      try {
        await publisher.start(truckId, initialStatus: status);
      } catch (e) {
        debugPrint('[LocationPublishingGate] start failed: $e');
        _activeTruckId = null;
      }
      return;
    }

    if (_activeStatus != status) {
      debugPrint(
        '[LocationPublishingGate] status change '
        '${_activeStatus.wireValue} -> ${status.wireValue}',
      );
      _activeStatus = status;
      try {
        await publisher.setStatus(status);
      } catch (e) {
        debugPrint('[LocationPublishingGate] setStatus failed: $e');
      }
    }
  }

  DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) {
      final asInt = int.tryParse(value);
      if (asInt != null) return DateTime.fromMillisecondsSinceEpoch(asInt);
      return DateTime.tryParse(value);
    }
    return null;
  }

  Future<void> _tryMarkArrived({
    required FiretruckAssignment assignment,
    required double latitude,
    required double longitude,
  }) async {
    final incidentId = assignment.incidentId;
    if (_arrivedMarkedIncidents.contains(incidentId) ||
        _arrivedWriteInFlight.contains(incidentId)) {
      return;
    }

    final existingArrivedAt =
        _toDateTime(assignment.incidentData['arrived_at']) ??
        _toDateTime(assignment.incidentData['arrivedAt']);
    if (existingArrivedAt != null) {
      _arrivedMarkedIncidents.add(incidentId);
      return;
    }

    final distanceMeters = Geolocator.distanceBetween(
      latitude,
      longitude,
      assignment.destination.latitude,
      assignment.destination.longitude,
    );
    if (distanceMeters > kDestinationArrivalRadiusMeters) return;

    _arrivedWriteInFlight.add(incidentId);
    try {
      await FirebaseDatabase.instance.ref('incident_reports/$incidentId').update({
        'arrived_at': ServerValue.timestamp,
        'updated_at': ServerValue.timestamp,
      });
      if (!mounted) return;
      _arrivedMarkedIncidents.add(incidentId);
      debugPrint(
        '[LocationPublishingGate] auto-arrived marked '
        'incident=$incidentId distance=${distanceMeters.toStringAsFixed(1)}m',
      );

      final publisher = ref.read(firetruckLocationPublisherProvider);
      if (publisher.currentTruckId == assignment.truckId) {
        _activeStatus = FiretruckStatus.onsite;
        await publisher.setStatus(FiretruckStatus.onsite);
      }
    } catch (e) {
      debugPrint('[LocationPublishingGate] auto-arrived failed: $e');
    } finally {
      _arrivedWriteInFlight.remove(incidentId);
    }
  }

  @override
  Widget build(BuildContext context) {
    _locationPublisher = ref.read(firetruckLocationPublisherProvider);

    // React to truck-id changes (login, logout, reassignment).
    ref.listen<AsyncValue<String?>>(myAssignedTruckIdProvider, (_, next) {
      next.whenData((_) => _resync());
    });

    // React to incident assignment changes (toggles status enroute <-> available).
    ref.listen<AsyncValue<dynamic>>(firetruckAssignmentRealtimeProvider, (
      _,
      next,
    ) {
      next.whenData((_) => _resync());
    });

    ref.listen<AsyncValue<String?>>(myAssignedTruckIdProvider, (_, truckNext) {
      final truckId = truckNext.value;
      if (truckId == null) return;
      final location = ref.read(firetruckLatLngProvider(truckId)).value;
      final assignment = ref.read(firetruckAssignmentRealtimeProvider).value;
      if (location == null || assignment == null) return;
      unawaited(
        _tryMarkArrived(
          assignment: assignment,
          latitude: location.latitude,
          longitude: location.longitude,
        ),
      );
    });

    final truckId = ref.watch(myAssignedTruckIdProvider).value;
    if (truckId != null) {
      ref.listen<AsyncValue<LatLng?>>(firetruckLatLngProvider(truckId), (
        _,
        next,
      ) {
        final location = next.value;
        final assignment = ref.read(firetruckAssignmentRealtimeProvider).value;
        if (location == null || assignment == null) return;
        unawaited(
          _tryMarkArrived(
            assignment: assignment,
            latitude: location.latitude,
            longitude: location.longitude,
          ),
        );
      });
    }

    return widget.child;
  }
}
