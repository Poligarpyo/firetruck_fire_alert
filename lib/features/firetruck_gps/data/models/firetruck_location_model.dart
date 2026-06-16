import '../../domain/entities/firetruck_location.dart';
import '../../domain/entities/firetruck_status.dart';

/// Wire-format model for `firetrucks/{truckId}` in Firebase Realtime Database.
///
/// Layout in RTDB:
/// ```
/// firetrucks/
///   {truckId}/
///     status: "available" | "dispatched" | "enroute" | "on-scene" | "offline"
///     lastSeen: <serverTimestamp>
///     location/
///       lat: 14.5995
///       lng: 120.9842
///       heading: 87.3       (optional)
///       speed: 12.4         (optional, m/s)
///       accuracy: 5.0       (optional, meters)
///       updatedAt: <serverTimestamp>
/// ```
class FiretruckLocationModel extends FiretruckLocation {
  const FiretruckLocationModel({
    required super.truckId,
    super.latitude,
    super.longitude,
    super.heading,
    super.speed,
    super.accuracy,
    super.updatedAt,
    super.lastSeen,
    super.status,
  });

  /// Builds a model from the full truck node `firetrucks/{truckId}` payload.
  ///
  /// Tolerates missing keys — RTDB may emit a partial node if writes haven't
  /// landed yet or `onDisconnect` cleared parts of it.
  factory FiretruckLocationModel.fromTruckNode(
    String truckId,
    Map<dynamic, dynamic> data,
  ) {
    final loc = data['location'];
    final locMap = loc is Map ? loc : const <dynamic, dynamic>{};

    return FiretruckLocationModel(
      truckId: truckId,
      latitude: _toDouble(locMap['lat']) ?? _toDouble(locMap['latitude']),
      longitude: _toDouble(locMap['lng']) ?? _toDouble(locMap['longitude']),
      heading: _toDouble(locMap['heading']),
      speed: _toDouble(locMap['speed']),
      accuracy: _toDouble(locMap['accuracy']),
      updatedAt: _toTimestamp(locMap['updatedAt']),
      lastSeen: _toTimestamp(data['lastSeen']),
      status: FiretruckStatus.fromWire(data['status'] as String?),
    );
  }

  /// Builds a model from just the `firetrucks/{truckId}/location` subtree.
  /// Used when listening to the location node directly.
  factory FiretruckLocationModel.fromLocationNode(
    String truckId,
    Map<dynamic, dynamic> data, {
    FiretruckStatus status = FiretruckStatus.offline,
    DateTime? lastSeen,
  }) {
    return FiretruckLocationModel(
      truckId: truckId,
      latitude: _toDouble(data['lat']) ?? _toDouble(data['latitude']),
      longitude: _toDouble(data['lng']) ?? _toDouble(data['longitude']),
      heading: _toDouble(data['heading']),
      speed: _toDouble(data['speed']),
      accuracy: _toDouble(data['accuracy']),
      updatedAt: _toTimestamp(data['updatedAt']),
      lastSeen: lastSeen,
      status: status,
    );
  }

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  static DateTime? _toTimestamp(dynamic v) {
    if (v is int) return DateTime.fromMillisecondsSinceEpoch(v);
    if (v is num) return DateTime.fromMillisecondsSinceEpoch(v.toInt());
    return null;
  }
}
