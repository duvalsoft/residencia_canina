// lib/src/data/daos/sync_log_dao.dart
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/sync_log_table.dart';

part 'sync_log_dao.g.dart';

@DriftAccessor(tables: [SyncLogTable])
class SyncLogDao extends DatabaseAccessor<AppDatabase> with _$SyncLogDaoMixin {
  SyncLogDao(AppDatabase db) : super(db);

  /// Crear un log de sincronización
  Future<int> createLog({
    required String entityType,
    required int entityId,
    required String operation,
    String status = 'pending',
    String? errorMessage,
  }) {
    return into(syncLogTable).insert(
      SyncLogTableCompanion(
        entityType: Value(entityType),
        entityId: Value(entityId),
        operation: Value(operation),
        status: Value(status),
        errorMessage: Value(errorMessage),
      ),
    );
  }

  /// Actualizar log de sincronización
  Future<void> updateLog(int id, String status, {String? errorMessage}) {
    return (update(syncLogTable)..where((t) => t.id.equals(id))).write(
      SyncLogTableCompanion(
        status: Value(status),
        errorMessage: Value(errorMessage),
        syncedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Obtener logs pendientes
  Future<List<SyncLogDb>> getPendingLogs() {
    return (select(syncLogTable)..where((t) => t.status.equals('pending')))
        .get();
  }

  /// Obtener logs por entidad
  Future<List<SyncLogDb>> getLogsByEntity(String entityType, int entityId) {
    return (select(syncLogTable)
          ..where((t) =>
              t.entityType.equals(entityType) & t.entityId.equals(entityId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Limpiar logs antiguos (más de 30 días)
  Future<int> cleanOldLogs() {
    final cutoffDate = DateTime.now().subtract(const Duration(days: 30));
    return (delete(syncLogTable)
          ..where((t) => t.createdAt.isSmallerThanValue(cutoffDate)))
        .go();
  }
}