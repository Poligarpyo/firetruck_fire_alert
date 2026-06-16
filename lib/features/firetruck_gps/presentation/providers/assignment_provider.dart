import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/storage/auth_local_datasource_provider.dart';
part 'assignment_provider.g.dart';

class FiretruckAssignment {
  const FiretruckAssignment({
    required this.truckId,
    required this.destination,
    required this.incidentId,
    required this.incidentData,
  });
  final String truckId;
  final LatLng destination;
  final String incidentId;
  final Map<String, dynamic> incidentData;
}

/// Resolves the firetruck doc id assigned to the currently logged-in user.
///
/// This is a stripped-down version of [firetruckAssignmentControllerProvider]
/// that does *not* require an active incident — used to start the location
/// publisher the moment the driver signs in, so dispatchers see them as
/// "available" on the fleet map immediately.
///
/// Re-emits whenever the `firetrucks` collection changes (e.g. when the
/// dispatcher reassigns the truck to a different officer).
@Riverpod(keepAlive: true)
Stream<String?> myAssignedTruckId(Ref ref) async* {
  final username = ref.read(authLocalDataSourceProvider).getLogin();
  if (username == null || username.trim().isEmpty) {
    yield null;
    return;
  }

  final firestore = FirebaseFirestore.instance;

  Future<String?> resolveTruckIdOrNull() async {
    try {
      ref.invalidate(firetruckAssignmentControllerProvider);
      final assignment = await ref
          .read(firetruckAssignmentControllerProvider.future)
          .timeout(const Duration(seconds: 8));
      return assignment.truckId;
    } catch (_) {
      // Either no incident yet (most common case for a freshly logged-in
      // driver) or no truck. Fall back to the truck-only lookup so we
      // can still publish location for an idle driver.
      return _findAssignedTruckIdFallback(firestore, username.trim());
    }
  }

  yield await resolveTruckIdOrNull();

  // Re-emit on truck reassignment.
  await for (final _ in firestore.collection('firetrucks').snapshots()) {
    yield await resolveTruckIdOrNull();
  }
}

/// Best-effort lookup of the truck doc id from the `firetrucks` collection
/// for a given username. Mirrors the matchers used by
/// `_findAssignedTruck` but only returns the doc id.
Future<String?> _findAssignedTruckIdFallback(
  FirebaseFirestore firestore,
  String username,
) async {
  final collection = firestore.collection('firetrucks');

  final exact = await collection
      .where('assigned_officer', isEqualTo: username)
      .limit(1)
      .get();
  if (exact.docs.isNotEmpty) return exact.docs.first.id;

  final lower = username.toLowerCase();
  if (lower != username) {
    final lowerExact = await collection
        .where('assigned_officer', isEqualTo: lower)
        .limit(1)
        .get();
    if (lowerExact.docs.isNotEmpty) return lowerExact.docs.first.id;
  }

  // Last resort: scan up to 100 docs and match normalized values.
  final all = await collection.limit(100).get();
  final target = username.trim().toLowerCase();
  for (final doc in all.docs) {
    final raw = doc.data()['assigned_officer'] ?? doc.data()['assignedOfficer'];
    final normalized = raw is String ? raw.trim().toLowerCase() : null;
    if (normalized == target) return doc.id;
  }
  return null;
}

/// Sentinel exception messages from [FiretruckAssignmentController.build].
/// Treated as "no assignment yet" rather than as failures so the UI can show
/// a friendly standby state instead of a red error message.
const _kNoAssignmentMessages = <String>[
  'No active incident assigned to this firetruck.',
  'No firetruck assigned to this account.',
];

bool _isExpectedNoAssignmentError(Object error) {
  final message = error.toString();
  return _kNoAssignmentMessages.any(message.contains);
}

@Riverpod(keepAlive: true)
Stream<FiretruckAssignment?> firetruckAssignmentRealtime(Ref ref) async* {
  final username = ref.read(authLocalDataSourceProvider).getLogin();
  if (username == null || username.trim().isEmpty) {
    yield null;
    return;
  }

  Future<FiretruckAssignment?> resolveAssignmentOrThrow() async {
    ref.invalidate(firetruckAssignmentControllerProvider);
    try {
      return await ref
          .read(firetruckAssignmentControllerProvider.future)
          .timeout(const Duration(seconds: 8));
    } catch (e) {
      // "No incident yet" / "No truck yet" => normal idle state, emit null.
      if (_isExpectedNoAssignmentError(e)) {
        // ignore: avoid_print
        print('[AssignmentRealtime] idle: $e');
        return null;
      }
      // Timeout/network/query failures should not lock the UI in red error.
      // Emit null so screen can keep running and wait for next realtime tick.
      if (e is TimeoutException) {
        // ignore: avoid_print
        print('[AssignmentRealtime] timeout: $e');
        return null;
      }
      // ignore: avoid_print
      print('[AssignmentRealtime] error -> fallback null: $e');
      return null;
    }
  }

  yield await resolveAssignmentOrThrow();

  final db = FirebaseDatabase.instance;
  await for (final _ in db.ref('incident_reports').onValue) {
    yield await resolveAssignmentOrThrow();
  }
}

Future<DataSnapshot?> _loadIncidentRoot() async {
  final db = FirebaseDatabase.instance;
  final reports = await db.ref('incident_reports').get();
  if (reports.value is Map) return reports;
  final incidents = await db.ref('incidents').get();
  if (incidents.value is Map) return incidents;
  return null;
}

@Riverpod(keepAlive: true)
class FiretruckAssignmentController extends _$FiretruckAssignmentController {
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  @override
  Future<FiretruckAssignment> build() async {
    final username = ref.read(authLocalDataSourceProvider).getLogin();
    if (username == null || username.trim().isEmpty) {
      throw Exception('Please log in to access the firetruck system.');
    }
    print('[Assignment] Current logged-in user: $username');

    final truckDoc = await _findAssignedTruck(username.trim());
    if (truckDoc == null) {
      throw Exception(
        'No firetruck assigned to your account. Please contact your dispatcher.',
      );
    }

    final truckData = truckDoc.data();
    if (truckData == null) {
      throw Exception(
        'Firetruck data could not be loaded. Please try again or contact support.',
      );
    }

    final truckCode = _extractTruckCode(truckData);
    if (truckCode == null) {
      throw Exception(
        'Assigned firetruck is missing required information. Please contact your administrator.',
      );
    }
    print(
      '[Assignment] Assigned firetruck -> id: ${truckDoc.id}, code: $truckCode',
    );

    final incidentDoc = await _findAssignedIncident(
      truckId: truckDoc.id,
      truckCode: truckCode,
      truckData: truckData,
      assignedOfficer: username.trim(),
    );
    if (incidentDoc == null) {
      throw Exception('No active incident assigned to this firetruck.');
    }

    final incidentData = incidentDoc.data;

    print(
      '[Assignment] Selected incident doc=${incidentDoc.id} '
      'fields=${incidentData.keys.toList()}',
    );

    final destination = _extractDestination(incidentData);
    if (destination == null) {
      print(
        '[Assignment] Destination extraction failed. Raw doc: $incidentData',
      );
      throw Exception(
        'Incident location is missing. Please contact your dispatcher to update the incident details.',
      );
    }

    return FiretruckAssignment(
      truckId: truckDoc.id,
      destination: destination,
      incidentId: incidentDoc.id,
      incidentData: Map<String, dynamic>.unmodifiable(incidentData),
    );
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> _findAssignedTruck(
    String username,
  ) async {
    final collection = _firestore.collection('firetrucks');
    print(
      '[Assignment] Firestore project: ${_firestore.app.options.projectId}',
    );
    final normalizedUsername = username.trim().toLowerCase();
    print('[Assignment] Query firetrucks where assigned_officer == $username');
    final exactAssignedOfficer = await collection
        .where('assigned_officer', isEqualTo: username)
        .limit(1)
        .get();
    print(
      '[Assignment] assigned_officer exact match count: ${exactAssignedOfficer.docs.length}',
    );
    if (exactAssignedOfficer.docs.isNotEmpty) {
      return exactAssignedOfficer.docs.first;
    }

    final lower = username.toLowerCase();
    if (lower != username) {
      print('[Assignment] Query firetrucks where assigned_officer == $lower');
      final lowerAssignedOfficer = await collection
          .where('assigned_officer', isEqualTo: lower)
          .limit(1)
          .get();
      print(
        '[Assignment] assigned_officer lowercase match count: ${lowerAssignedOfficer.docs.length}',
      );
      if (lowerAssignedOfficer.docs.isNotEmpty) {
        return lowerAssignedOfficer.docs.first;
      }
    }

    // Final diagnostic fallback: inspect docs directly and match normalized values.
    final allDocs = await collection.limit(100).get();
    print(
      '[Assignment] Fallback scan firetrucks docs count: ${allDocs.docs.length}',
    );
    for (final doc in allDocs.docs) {
      final data = doc.data();
      final assignedOfficerValue =
          data['assigned_officer'] ?? data['assignedOfficer'];
      String? assignedOfficerNormalized;

      if (assignedOfficerValue is String) {
        assignedOfficerNormalized = assignedOfficerValue.trim().toLowerCase();
      } else if (assignedOfficerValue
          is DocumentReference<Map<String, dynamic>>) {
        assignedOfficerNormalized = assignedOfficerValue.id
            .trim()
            .toLowerCase();
      }

      print(
        '[Assignment] firetruck doc=${doc.id}, assigned_officer=$assignedOfficerValue, normalized=$assignedOfficerNormalized',
      );

      if (assignedOfficerNormalized == normalizedUsername) {
        print('[Assignment] Matched via fallback scan: ${doc.id}');
        return doc;
      }
    }

    final agentIdentifiers = await _resolveAgentIdentifiers(username);
    print(
      '[Assignment] Resolved agent IDs: ${agentIdentifiers.agentIds.join(', ')}',
    );

    final stringFieldCandidates = <String>[
      'assigned_officer',
      'assignedOfficer',
      'assignedAgentId',
      'assigned_agent_id',
      'assignedTo',
      'assigned_to',
      'agentId',
      'agent_id',
      'username',
      'userId',
      'user_id',
    ];

    for (final field in stringFieldCandidates) {
      for (final identifier in agentIdentifiers.agentIds) {
        final snapshot = await collection
            .where(field, isEqualTo: identifier)
            .limit(1)
            .get();
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs.first;
        }
      }
    }

    final referenceFieldCandidates = <String>[
      'assigned_officer',
      'assignedOfficer',
    ];
    for (final field in referenceFieldCandidates) {
      for (final agentRef in agentIdentifiers.agentRefs) {
        final snapshot = await collection
            .where(field, isEqualTo: agentRef)
            .limit(1)
            .get();
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs.first;
        }
      }
    }

    for (final identifier in agentIdentifiers.agentIds) {
      final directDoc = await collection.doc(identifier).get();
      if (directDoc.exists && directDoc.data() != null) {
        return directDoc;
      }
    }

    return null;
  }

  Future<_AgentIdentifiers> _resolveAgentIdentifiers(String username) async {
    final agents = _firestore.collection('agents');
    final agentIds = <String>{username, username.toLowerCase()};
    final agentRefs = <DocumentReference<Map<String, dynamic>>>{
      agents.doc(username),
      agents.doc(username.toLowerCase()),
    };

    for (final id in agentIds.toList()) {
      final doc = await agents.doc(id).get();
      if (doc.exists) {
        agentIds.add(doc.id);
        agentRefs.add(doc.reference);
      }
    }

    final byUsername = await agents
        .where('username', isEqualTo: username)
        .limit(1)
        .get();
    if (byUsername.docs.isNotEmpty) {
      agentIds.add(byUsername.docs.first.id);
      agentRefs.add(byUsername.docs.first.reference);
    }

    final lower = username.toLowerCase();
    if (lower != username) {
      final byUsernameLower = await agents
          .where('username', isEqualTo: lower)
          .limit(1)
          .get();
      if (byUsernameLower.docs.isNotEmpty) {
        agentIds.add(byUsernameLower.docs.first.id);
        agentRefs.add(byUsernameLower.docs.first.reference);
      }
    }

    return _AgentIdentifiers(agentIds: agentIds, agentRefs: agentRefs);
  }

  Future<_IncidentRecord?> _findAssignedIncident({
    required String truckId,
    required String truckCode,
    required Map<String, dynamic> truckData,
    required String assignedOfficer,
  }) async {
    final snapshot = await _loadIncidentRoot().timeout(
      const Duration(seconds: 6),
    );
    if (snapshot == null) return null;
    final raw = snapshot.value;
    if (raw is! Map) return null;

    final incidents = <_IncidentRecord>[];
    raw.forEach((key, value) {
      if (key is! String || value is! Map) return;
      final map = Map<String, dynamic>.from(value);
      incidents.add(_IncidentRecord(key, map));
    });

    bool matchesTruck(_IncidentRecord incident) {
      final data = incident.data;
      final normalizedTruckCode = _normalizeToken(truckCode);
      final normalizedTruckId = _normalizeToken(truckId);
      final normalizedOfficer = _normalizeToken(assignedOfficer);
      final candidates = <dynamic>[
        data['assignedFiretruck'],
        data['assigned_firetruck'],
        data['assignedFiretruckId'],
        data['assigned_firetruck_id'],
        data['firetruckId'],
        data['firetruck_id'],
        data['truckId'],
        data['truck_id'],
        data['firetruckCode'],
        data['firetruck_code'],
        data['truckCode'],
        data['truck_code'],
      ];

      for (final value in candidates) {
        if (value is String) {
          final normalized = _normalizeToken(value);
          if (normalized.isEmpty) continue;
          if (normalized == normalizedTruckCode ||
              normalized == normalizedTruckId) {
            return true;
          }
        }
      }

      final officer = data['assignedOfficer'];
      if (officer is String && _normalizeToken(officer) == normalizedOfficer) {
        return true;
      }
      return false;
    }

    for (final incident in incidents) {
      if (!matchesTruck(incident)) continue;
      if (_isActiveIncident(incident.data)) return incident;
    }

    final viaTruck = await _resolveIncidentViaTruckField(truckData, incidents)
        .timeout(
          const Duration(seconds: 6),
          onTimeout: () {
            print('[Assignment] truck-field incident resolution timed out');
            return null;
          },
        );
    return viaTruck;
  }

  /// Reads `assigned_incidents` (or common variants) off the truck doc and
  /// returns the first active incident referenced by it.
  ///
  /// Supports values shaped like:
  ///   * `["INC-001", "INC-002"]`
  ///   * `{"INC-001": true, ...}`
  ///   * `[DocumentReference, ...]`
  ///   * `"INC-001"` (single id)
  Future<_IncidentRecord?> _resolveIncidentViaTruckField(
    Map<String, dynamic> truckData,
    List<_IncidentRecord> incidents,
  ) async {
    const truckFieldCandidates = <String>[
      'assigned_incidents',
      'assignedIncidents',
      'assigned_incident',
      'assignedIncident',
      'incident_id',
      'incidentId',
      'currentIncidentId',
      'current_incident_id',
    ];

    final ids = <String>[];
    final refs = <DocumentReference<Map<String, dynamic>>>[];

    for (final field in truckFieldCandidates) {
      final raw = truckData[field];
      if (raw == null) continue;

      if (raw is String && raw.trim().isNotEmpty) {
        ids.add(raw.trim());
      } else if (raw is DocumentReference<Map<String, dynamic>>) {
        refs.add(raw);
      } else if (raw is List) {
        for (final item in raw) {
          if (item is String && item.trim().isNotEmpty) {
            ids.add(item.trim());
          } else if (item is DocumentReference<Map<String, dynamic>>) {
            refs.add(item);
          } else if (item is Map && item['id'] is String) {
            ids.add((item['id'] as String).trim());
          }
        }
      } else if (raw is Map) {
        raw.forEach((key, _) {
          if (key is String && key.trim().isNotEmpty) ids.add(key.trim());
        });
      }
    }

    if (ids.isEmpty && refs.isEmpty) return null;
    print(
      '[Assignment] truck.assigned_incidents -> ids=$ids refs=${refs.map((r) => r.path).toList()}',
    );

    for (final id in ids) {
      for (final incident in incidents) {
        if (incident.id != id) continue;
        if (_isActiveIncident(incident.data)) return incident;
      }
    }
    for (final ref in refs) {
      final refId = ref.path.split('/').last;
      for (final incident in incidents) {
        if (incident.id != refId) continue;
        if (_isActiveIncident(incident.data)) return incident;
      }
    }
    return null;
  }

  bool _isActiveIncident(Map<String, dynamic> data) {
    final status = (data['status'] as String?)?.toLowerCase().trim();
    final statusLabel = (data['status_label'] as String?)?.toLowerCase().trim();

    bool isTerminal(String? value) {
      if (value == null || value.isEmpty) return false;
      return value == 'completed' ||
          value == 'resolved' ||
          value == 'closed' ||
          value == 'done';
    }

    if (isTerminal(status) || isTerminal(statusLabel)) {
      return false;
    }

    return true;
  }

  LatLng? _extractDestination(Map<String, dynamic> data) {
    final lat =
        _toDouble(data['latitude']) ??
        _toDouble(data['Latitude']) ??
        _toDouble(data['lat']);
    final lng =
        _toDouble(data['longitude']) ??
        _toDouble(data['Longitude']) ??
        _toDouble(data['lng']);
    if (lat != null && lng != null) {
      return LatLng(lat, lng);
    }

    final locationMap = data['location'];
    if (locationMap is Map<String, dynamic>) {
      final nestedLat =
          _toDouble(locationMap['latitude']) ?? _toDouble(locationMap['lat']);
      final nestedLng =
          _toDouble(locationMap['longitude']) ?? _toDouble(locationMap['lng']);
      if (nestedLat != null && nestedLng != null) {
        return LatLng(nestedLat, nestedLng);
      }
    }

    return null;
  }

  double? _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  String? _extractTruckCode(Map<String, dynamic> data) {
    final codeCandidates = <String>[
      'firetruckCode',
      'firetruck_code',
      'truckCode',
      'truck_code',
      'code',
    ];

    for (final key in codeCandidates) {
      final value = data[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return null;
  }

  String _normalizeToken(String value) => value.trim().toLowerCase();
}

class _AgentIdentifiers {
  final Set<String> agentIds;
  final Set<DocumentReference<Map<String, dynamic>>> agentRefs;

  const _AgentIdentifiers({required this.agentIds, required this.agentRefs});
}

class _IncidentRecord {
  final String id;
  final Map<String, dynamic> data;

  const _IncidentRecord(this.id, this.data);
}
