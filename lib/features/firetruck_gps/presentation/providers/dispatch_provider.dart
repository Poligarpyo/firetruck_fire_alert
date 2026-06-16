import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../data/enums/dispatch_status.dart';

class DispatchState {
  final DispatchStatus status;
  final DateTime? acceptedTime;
  final DateTime? arrivedTime;
  final DateTime? resolvedTime;

  const DispatchState({
    required this.status,
    this.acceptedTime,
    this.arrivedTime,
    this.resolvedTime,
  });

  DispatchState copyWith({
    DispatchStatus? status,
    DateTime? acceptedTime,
    DateTime? arrivedTime,
    DateTime? resolvedTime,
  }) {
    return DispatchState(
      status: status ?? this.status,
      acceptedTime: acceptedTime ?? this.acceptedTime,
      arrivedTime: arrivedTime ?? this.arrivedTime,
      resolvedTime: resolvedTime ?? this.resolvedTime,
    );
  }
}

class DispatchNotifier extends StateNotifier<DispatchState> {
  DispatchNotifier() : super(const DispatchState(status: DispatchStatus.none));

  void simulateDispatch() {
    state = const DispatchState(status: DispatchStatus.pending);
  }

  Future<void> acceptDispatch({required String incidentId}) async {
    final incidentRef = FirebaseDatabase.instance.ref(
      'incident_reports/$incidentId',
    );
    final snapshot = await incidentRef.get();
    final raw = snapshot.value;
    final updates = <String, dynamic>{
      'status': 'responding',
      'updated_at': ServerValue.timestamp,
    };
    if (raw is Map && raw['assigned_at'] == null && raw['assignedAt'] == null) {
      updates['assigned_at'] = ServerValue.timestamp;
    }
    await incidentRef.update(updates);

    state = state.copyWith(
      status: DispatchStatus.accepted,
      acceptedTime: DateTime.now(),
    );
  }

  Future<void> completeDispatch({
    required String incidentId,
    required DateTime resolvedAt,
  }) async {
    final incidentRef = FirebaseDatabase.instance.ref(
      'incident_reports/$incidentId',
    );
    final snapshot = await incidentRef.get();
    DateTime arrivedAt = DateTime.now();
    final raw = snapshot.value;
    if (raw is Map) {
      final dynamic arrivedRaw = raw['arrived_at'] ?? raw['arrivedAt'];
      if (arrivedRaw is int) {
        arrivedAt = DateTime.fromMillisecondsSinceEpoch(arrivedRaw);
      } else if (arrivedRaw is String) {
        final asInt = int.tryParse(arrivedRaw);
        if (asInt != null) {
          arrivedAt = DateTime.fromMillisecondsSinceEpoch(asInt);
        } else {
          final asDate = DateTime.tryParse(arrivedRaw);
          if (asDate != null) {
            arrivedAt = asDate;
          }
        }
      }
    }

    await incidentRef.update({
      'arrived_at': arrivedAt.millisecondsSinceEpoch,
      'resolved_at': resolvedAt.millisecondsSinceEpoch,
      'status': 'resolved',
      'updated_at': ServerValue.timestamp,
    });

    state = state.copyWith(
      status: DispatchStatus.completed,
      arrivedTime: arrivedAt,
      resolvedTime: resolvedAt,
    );
  }

  void resetDispatch() {
    state = const DispatchState(status: DispatchStatus.none);
  }
}
