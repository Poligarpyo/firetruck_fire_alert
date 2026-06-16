/// Parses incident timestamp fields from Firebase RTDB (int ms, string, or DateTime).
DateTime? parseIncidentTimestamp(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  if (value is double) return DateTime.fromMillisecondsSinceEpoch(value.round());
  if (value is num) return DateTime.fromMillisecondsSinceEpoch(value.round());
  if (value is String) {
    final asInt = int.tryParse(value);
    if (asInt != null) {
      return DateTime.fromMillisecondsSinceEpoch(asInt);
    }
    return DateTime.tryParse(value);
  }
  return null;
}

/// True when the officer/truck has been marked on scene (`arrived_at` set).
bool incidentHasArrived(Map<String, dynamic> incidentData) {
  return parseIncidentTimestamp(incidentData['arrived_at']) != null ||
      parseIncidentTimestamp(incidentData['arrivedAt']) != null;
}
