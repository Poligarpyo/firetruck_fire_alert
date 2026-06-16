import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/storage/auth_local_datasource_provider.dart';
import '../../../../core/utils/incident_timestamp.dart';
import 'assignment_provider.dart';

part 'dispatch_feed_provider.g.dart';

class DispatchInfo {
  final String incidentId;
  final String reporterName;
  final String? reporterPhone;
  final String source;
  final DateTime? createdAt;
  final DateTime? assignedAt;
  final DateTime? arrivedAt;
  final DateTime? resolvedAt;
  final String details;
  final String address;
  final LatLng destination;
  final String? photoUrl;
  final Map<String, dynamic> incidentData;

  const DispatchInfo({
    required this.incidentId,
    required this.reporterName,
    required this.reporterPhone,
    required this.source,
    required this.createdAt,
    required this.assignedAt,
    required this.arrivedAt,
    required this.resolvedAt,
    required this.details,
    required this.address,
    required this.destination,
    required this.photoUrl,
    required this.incidentData,
  });
}

@riverpod
Stream<List<DispatchInfo>> assignedDispatchFeed(Ref ref) async* {
  final username = ref.read(authLocalDataSourceProvider).getLogin();
  if (username == null || username.trim().isEmpty) {
    yield const [];
    return;
  }

  Future<List<DispatchInfo>> resolveLatest() async {
    try {
      ref.invalidate(firetruckAssignmentControllerProvider);
      final assignment = await ref.read(
        firetruckAssignmentControllerProvider.future,
      );
      return [_toDispatchInfo(assignment)];
    } catch (_) {
      return const [];
    }
  }

  yield await resolveLatest();

  await for (final _
      in FirebaseDatabase.instance.ref('incident_reports').onValue) {
    yield await resolveLatest();
  }
}

DispatchInfo _toDispatchInfo(FiretruckAssignment assignment) {
  final data = assignment.incidentData;

  final reporterName =
      _firstNonEmptyString(data, [
        'reporterName',
        'reporter_name',
        'reportedBy',
        'reported_by',
        'name',
      ]) ??
      'Unknown Reporter';

  final reporterPhone = _firstNonEmptyString(data, [
    'reporterPhone',
    'reporter_phone',
    'phone',
    'contactNumber',
    'contact_number',
  ]);

  final source =
      _firstNonEmptyString(data, [
        'source',
        'reportSource',
        'report_source',
        'channel',
      ]) ??
      'Dispatch';

  final details =
      _firstNonEmptyString(data, [
        'details',
        'description',
        'incidentDetails',
        'incident_details',
      ]) ??
      'No incident details provided.';

  final address =
      _firstNonEmptyString(data, [
        'address',
        'locationAddress',
        'location_address',
        'incidentAddress',
        'incident_address',
      ]) ??
      '${assignment.destination.latitude}, ${assignment.destination.longitude}';

  return DispatchInfo(
    incidentId: assignment.incidentId,
    reporterName: reporterName,
    reporterPhone: reporterPhone,
    source: source,
    createdAt:
        parseIncidentTimestamp(data['created_at']) ??
        parseIncidentTimestamp(data['createdAt']),
    assignedAt:
        parseIncidentTimestamp(data['assigned_at']) ??
        parseIncidentTimestamp(data['assignedAt']),
    arrivedAt:
        parseIncidentTimestamp(data['arrived_at']) ??
        parseIncidentTimestamp(data['arrivedAt']),
    resolvedAt:
        parseIncidentTimestamp(data['resolved_at']) ??
        parseIncidentTimestamp(data['resolvedAt']),
    details: details,
    address: address,
    destination: assignment.destination,
    photoUrl: _firstNonEmptyString(data, [
      'photoUrl',
      'photo_url',
      'imageUrl',
      'image_url',
      'image',
    ]),
    incidentData: data,
  );
}

String? _firstNonEmptyString(Map<String, dynamic> data, List<String> keys) {
  for (final key in keys) {
    final value = data[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
  }
  return null;
}

