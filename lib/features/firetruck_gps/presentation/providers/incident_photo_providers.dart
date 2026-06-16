import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/database_providers.dart';
import '../../data/services/incident_photo_service.dart';

final incidentPhotoServiceProvider = Provider<IncidentPhotoService>((ref) {
  return IncidentPhotoService(database: ref.watch(appDatabaseProvider));
});

final incidentPhotoStatusProvider =
    FutureProvider.family<IncidentPhotoStatus, IncidentPhotoRequest>((
  ref,
  request,
) async {
  return ref.read(incidentPhotoServiceProvider).getStatus(
        incidentId: request.incidentId,
        incidentData: request.incidentData,
      );
});

class IncidentPhotoRequest {
  const IncidentPhotoRequest({
    required this.incidentId,
    this.incidentData,
  });

  final String incidentId;
  final Map<String, dynamic>? incidentData;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncidentPhotoRequest &&
          incidentId == other.incidentId;

  @override
  int get hashCode => incidentId.hashCode;
}
