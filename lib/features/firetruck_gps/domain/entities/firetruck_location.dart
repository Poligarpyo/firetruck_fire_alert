import 'firetruck_status.dart';

/// Snapshot of a firetruck's location + telemetry at a point in time.
///
/// All fields except [truckId] can be null because RTDB may emit a partial
/// node (e.g. before the very first write, or after `onDisconnect` fires and
/// only `status` + `lastSeen` remain).
class FiretruckLocation {
  final String truckId;
  final double? latitude;
  final double? longitude;

  /// Compass heading in degrees (0–360, null if device hasn't reported one).
  final double? heading;

  /// Ground speed in m/s.
  final double? speed;

  /// Reported horizontal accuracy in meters.
  final double? accuracy;

  /// Server-side timestamp of the last `location` write.
  final DateTime? updatedAt;

  /// Server-side timestamp of the last presence ping (heartbeat or write).
  final DateTime? lastSeen;

  /// Operational status (see [FiretruckStatus]).
  final FiretruckStatus status;

  const FiretruckLocation({
    required this.truckId,
    this.latitude,
    this.longitude,
    this.heading,
    this.speed,
    this.accuracy,
    this.updatedAt,
    this.lastSeen,
    this.status = FiretruckStatus.offline,
  });

  /// True when we have a usable lat/lng pair to draw on the map.
  bool get hasFix => latitude != null && longitude != null;

  /// True when the truck has been heard from in the last [staleAfter].
  bool isFresh({Duration staleAfter = const Duration(seconds: 30)}) {
    final ts = lastSeen ?? updatedAt;
    if (ts == null) return false;
    return DateTime.now().difference(ts) <= staleAfter;
  }

  FiretruckLocation copyWith({
    String? truckId,
    double? latitude,
    double? longitude,
    double? heading,
    double? speed,
    double? accuracy,
    DateTime? updatedAt,
    DateTime? lastSeen,
    FiretruckStatus? status,
  }) {
    return FiretruckLocation(
      truckId: truckId ?? this.truckId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      heading: heading ?? this.heading,
      speed: speed ?? this.speed,
      accuracy: accuracy ?? this.accuracy,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSeen: lastSeen ?? this.lastSeen,
      status: status ?? this.status,
    );
  }
}
