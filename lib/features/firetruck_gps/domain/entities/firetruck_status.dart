/// Operational status of a firetruck on the dispatcher map.
///
/// Stored as a lowercase string in RTDB (`firetrucks/{truckId}/status`) so it
/// can be validated by security rules and compared in queries.
enum FiretruckStatus {
  /// Truck is offline (app closed, no network, or onDisconnect fired).
  offline,

  /// Truck is online and available for dispatch.
  available,

  /// Truck has been assigned an incident but has not started moving.
  dispatched,

  /// Truck is en route to the incident.
  enroute,

  /// Truck has arrived on scene.
  onsite;

  /// Value written to `firetrucks/{truckId}/status` in RTDB.
  String get wireValue {
    switch (this) {
      case FiretruckStatus.onsite:
        return 'on-scene';
      default:
        return name;
    }
  }

  static FiretruckStatus fromWire(String? value) {
    if (value == null || value.trim().isEmpty) {
      return FiretruckStatus.offline;
    }
    final v = value.trim();
    if (v == 'on-scene' || v == 'onsite') return FiretruckStatus.onsite;
    return FiretruckStatus.values.firstWhere(
      (e) => e.name == v,
      orElse: () => FiretruckStatus.offline,
    );
  }
}
