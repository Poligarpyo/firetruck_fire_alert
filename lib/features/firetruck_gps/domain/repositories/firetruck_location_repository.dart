import '../entities/firetruck_location.dart';
import '../entities/firetruck_status.dart';

abstract class FiretruckLocationRepository {
  /// Pushes the latest GPS sample for [truckId].
  /// Optional fields are skipped when null so we don't write empty keys.
  Future<void> updateLocation({
    required String truckId,
    required double latitude,
    required double longitude,
    double? heading,
    double? speed,
    double? accuracy,
  });

  /// Sets the operational status without changing location.
  Future<void> setStatus({
    required String truckId,
    required FiretruckStatus status,
  });

  /// Emits a [FiretruckLocation] (or `null` if the node is empty) whenever
  /// the truck's RTDB record changes.
  Stream<FiretruckLocation?> watchTruck(String truckId);

  /// Emits the list of all trucks. Designed for the dispatcher's fleet map.
  Stream<List<FiretruckLocation>> watchFleet();

  /// Registers `onDisconnect` handlers and marks the truck online.
  /// Call once after the driver authenticates.
  Future<void> setupPresence({
    required String truckId,
    FiretruckStatus initialStatus,
  });
}
