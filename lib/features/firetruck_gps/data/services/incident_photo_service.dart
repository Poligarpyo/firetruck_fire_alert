import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/incident_photo_kind.dart';

class IncidentPhotoStatus {
  const IncidentPhotoStatus({
    required this.hasBefore,
    required this.hasAfter,
    this.beforeLocalPath,
    this.afterLocalPath,
    this.beforeRemoteUrl,
    this.afterRemoteUrl,
    this.beforePendingSync = false,
    this.afterPendingSync = false,
  });

  final bool hasBefore;
  final bool hasAfter;
  final String? beforeLocalPath;
  final String? afterLocalPath;
  final String? beforeRemoteUrl;
  final String? afterRemoteUrl;
  final bool beforePendingSync;
  final bool afterPendingSync;

  bool get canCompleteResponse => hasBefore && hasAfter;
}

class IncidentPhotoService {
  IncidentPhotoService({
    required AppDatabase database,
    FirebaseStorage? storage,
    Connectivity? connectivity,
    ImagePicker? imagePicker,
  }) : _database = database,
       _storage = storage ?? FirebaseStorage.instance,
       _connectivity = connectivity ?? Connectivity(),
       _imagePicker = imagePicker ?? ImagePicker();

  final AppDatabase _database;
  final FirebaseStorage _storage;
  final Connectivity _connectivity;
  final ImagePicker _imagePicker;

  static const Duration _uploadTimeout = Duration(seconds: 30);

  Future<bool> _isOnline() async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  Future<bool> _ensureCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<String?> capturePhoto({
    required String incidentId,
    required IncidentPhotoKind kind,
  }) async {
    if (!await _ensureCameraPermission()) return null;

    final picked = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 1920,
    );
    if (picked == null) return null;

    final localPath = await _persistLocally(
      incidentId: incidentId,
      kind: kind,
      sourcePath: picked.path,
    );

    final id = '${incidentId}_${kind.wireValue}';
    await _database.insertPendingPhoto(
      PendingIncidentPhotosCompanion(
        id: Value(id),
        incidentId: Value(incidentId),
        kind: Value(kind.wireValue),
        localPath: Value(localPath),
        syncStatus: const Value(0),
        createdAt: Value(DateTime.now()),
      ),
    );

    if (await _isOnline()) {
      await syncPendingPhotos(incidentId: incidentId);
    }

    return localPath;
  }

  Future<String> _persistLocally({
    required String incidentId,
    required IncidentPhotoKind kind,
    required String sourcePath,
  }) async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(
      p.join(docs.path, 'incident_photos', incidentId, kind.storageFolder),
    );
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}${p.extension(sourcePath)}';
    final destPath = p.join(dir.path, fileName);
    await File(sourcePath).copy(destPath);
    return destPath;
  }

  Future<IncidentPhotoStatus> getStatus({
    required String incidentId,
    Map<String, dynamic>? incidentData,
  }) async {
    final data = incidentData ?? {};
    final beforeRemote = _readRemoteUrl(data, IncidentPhotoKind.before);
    final afterRemote = _readRemoteUrl(data, IncidentPhotoKind.after);

    final beforeLocal = await _database.getPhotoForIncident(
      incidentId: incidentId,
      kind: IncidentPhotoKind.before.wireValue,
    );
    final afterLocal = await _database.getPhotoForIncident(
      incidentId: incidentId,
      kind: IncidentPhotoKind.after.wireValue,
    );

    final beforePath = beforeLocal?.localPath;
    final afterPath = afterLocal?.localPath;
    final hasBefore =
        beforeRemote != null ||
        (beforePath != null && await File(beforePath).exists());
    final hasAfter =
        afterRemote != null ||
        (afterPath != null && await File(afterPath).exists());

    return IncidentPhotoStatus(
      hasBefore: hasBefore,
      hasAfter: hasAfter,
      beforeLocalPath: beforePath,
      afterLocalPath: afterPath,
      beforeRemoteUrl: beforeRemote,
      afterRemoteUrl: afterRemote,
      beforePendingSync: beforeLocal?.syncStatus == 0,
      afterPendingSync: afterLocal?.syncStatus == 0,
    );
  }

  String? _readRemoteUrl(Map<String, dynamic> data, IncidentPhotoKind kind) {
    final keys = kind == IncidentPhotoKind.before
        ? [
            'officer_before_photo_url',
            'officerBeforePhotoUrl',
            'before_photo_url',
          ]
        : [
            'officer_after_photo_url',
            'officerAfterPhotoUrl',
            'after_photo_url',
          ];
    for (final key in keys) {
      final value = data[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    return null;
  }

  Future<int> syncPendingPhotos({String? incidentId}) async {
    if (!await _isOnline()) return 0;

    final pending = await _database.getPendingIncidentPhotos();
    final toSync = incidentId == null
        ? pending
        : pending.where((p) => p.incidentId == incidentId).toList();

    var synced = 0;
    for (final photo in toSync) {
      final file = File(photo.localPath);
      if (!await file.exists()) {
        debugPrint(
          '[IncidentPhotoService] Photo file not found: ${photo.localPath}. Skipping sync - photo may have been deleted.',
        );
        continue;
      }

      final kind = IncidentPhotoKind.fromWire(photo.kind);
      try {
        final ref = _storage.ref(
          'incident_reports/${photo.incidentId}/${kind.storageFolder}/${photo.id}.jpg',
        );
        await ref.putFile(file).timeout(_uploadTimeout);
        final downloadUrl = await ref.getDownloadURL().timeout(_uploadTimeout);

        await FirebaseDatabase.instance
            .ref('incident_reports/${photo.incidentId}')
            .update({
              kind.rtdbUrlField: downloadUrl,
              kind.rtdbAtField: DateTime.now().millisecondsSinceEpoch,
              'updated_at': ServerValue.timestamp,
            });

        await _database.markPhotoSynced(id: photo.id, downloadUrl: downloadUrl);
        synced++;
        debugPrint(
          '[IncidentPhotoService] synced ${kind.storageFolder} '
          'incident=${photo.incidentId}',
        );
      } catch (e) {
        debugPrint(
          '[IncidentPhotoService] Failed to upload photo ${photo.id}: $e. Will retry automatically.',
        );
      }
    }
    return synced;
  }
}
