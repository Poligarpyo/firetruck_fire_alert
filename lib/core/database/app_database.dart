import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

part 'app_database.g.dart';

class EmergencyReports extends Table {
  TextColumn get id => text()();
  TextColumn get message => text()();
  TextColumn get phoneNumber => text().nullable()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  IntColumn get sentViaSms => integer()(); // 1 = true, 0 = false
  IntColumn get syncStatus =>
      integer().withDefault(const Constant(0))(); // 0 = pending
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Offline queue for officer before/after incident photos.
/// kind: 0 = before (on scene), 1 = after (resolved)
class PendingIncidentPhotos extends Table {
  TextColumn get id => text()();
  TextColumn get incidentId => text()();
  IntColumn get kind => integer()();
  TextColumn get localPath => text()();
  IntColumn get syncStatus =>
      integer().withDefault(const Constant(0))(); // 0=pending, 2=synced
  TextColumn get downloadUrl => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [EmergencyReports, PendingIncidentPhotos])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(pendingIncidentPhotos);
      }
    },
  );

  /// 0 = pending
  /// 1 = syncing (optional)
  /// 2 = synced

  // Get all pending reports
  Future<List<EmergencyReport>> getPendingReports() => (select(
    emergencyReports,
  )..where((tbl) => tbl.syncStatus.equals(0))).get();

  // Insert a report
  Future<void> insertReport(EmergencyReportsCompanion report) =>
      into(emergencyReports).insert(report, mode: InsertMode.insertOrReplace);

  // Mark single report as synced
  Future<void> markAsSynced(String id) async {
    await (update(emergencyReports)..where((tbl) => tbl.id.equals(id))).write(
      const EmergencyReportsCompanion(syncStatus: Value(2)),
    );
  }

  // Optional: mark as syncing (if you want crash safety)
  Future<void> markAsSyncing(String id) async {
    await (update(emergencyReports)..where((tbl) => tbl.id.equals(id))).write(
      const EmergencyReportsCompanion(syncStatus: Value(1)),
    );
  }

  // Delete synced reports older than specific date
  Future<int> deleteSyncedOlderThan(DateTime date) async {
    return await (delete(emergencyReports)..where(
          (tbl) =>
              tbl.syncStatus.equals(2) & tbl.createdAt.isSmallerThanValue(date),
        ))
        .go(); // go() returns number of rows deleted
  }

  Future<void> updateReportSyncStatus(String id, {bool sent = false}) async {
    await (update(emergencyReports)..where((tbl) => tbl.id.equals(id))).write(
      EmergencyReportsCompanion(
        sentViaSms: Value(sent ? 1 : 0),
        syncStatus: Value(sent ? 1 : 0),
      ),
    );
  }

  Future<int> deleteAllReports() {
    return delete(emergencyReports).go();
  }

  // ── Pending incident photos (offline upload queue) ───────────────────────

  Future<List<PendingIncidentPhoto>> getPendingIncidentPhotos() =>
      (select(pendingIncidentPhotos)
            ..where((tbl) => tbl.syncStatus.equals(0)))
          .get();

  Future<PendingIncidentPhoto?> getPhotoForIncident({
    required String incidentId,
    required int kind,
  }) =>
      (select(pendingIncidentPhotos)
            ..where(
              (tbl) =>
                  tbl.incidentId.equals(incidentId) & tbl.kind.equals(kind),
            )
            ..limit(1))
          .getSingleOrNull();

  Future<void> insertPendingPhoto(PendingIncidentPhotosCompanion photo) =>
      into(pendingIncidentPhotos).insert(
        photo,
        mode: InsertMode.insertOrReplace,
      );

  Future<void> markPhotoSynced({
    required String id,
    required String downloadUrl,
  }) async {
    await (update(pendingIncidentPhotos)..where((tbl) => tbl.id.equals(id)))
        .write(
      PendingIncidentPhotosCompanion(
        syncStatus: const Value(2),
        downloadUrl: Value(downloadUrl),
      ),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app.db'));
    return NativeDatabase(file);
  });
}
