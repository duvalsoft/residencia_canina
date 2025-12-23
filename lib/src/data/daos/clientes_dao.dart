// lib/src/data/daos/clientes_dao.dart
import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/clientes_table.dart';

part 'clientes_dao.g.dart';

@DriftAccessor(tables: [ClientesTable])
class ClientesDao extends DatabaseAccessor<AppDatabase> with _$ClientesDaoMixin {
  ClientesDao(super.db);

  // ==================== LECTURA ====================

  /// Stream de todos los clientes activos (no eliminados)
  Stream<List<ClienteDb>> watchAllClientes() {
    return (select(clientesTable)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  /// Obtener todos los clientes (para sincronización)
  Future<List<ClienteDb>> getAllClientes() {
    return (select(clientesTable)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  /// Obtener cliente por ID local
  Future<ClienteDb?> getClienteById(int id) {
    return (select(clientesTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Obtener cliente por ID de Odoo
  Future<ClienteDb?> getClienteByOdooId(int odooId) {
    return (select(clientesTable)..where((t) => t.odooId.equals(odooId)))
        .getSingleOrNull();
  }

  /// Buscar clientes por nombre o email
  Future<List<ClienteDb>> searchClientes(String query) {
    final pattern = '%${query.toLowerCase()}%';
    return (select(clientesTable)
          ..where((t) =>
              t.name.lower().like(pattern) |
              t.email.lower().like(pattern))
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  /// Obtener clientes con cambios pendientes de sincronizar
  Future<List<ClienteDb>> getClientesPendientes() {
    return (select(clientesTable)
          ..where((t) => t.hasPendingChanges.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.updatedAt)]))
        .get();
  }

  /// Obtener clientes no sincronizados
  Future<List<ClienteDb>> getClientesNoSincronizados() {
    return (select(clientesTable)
          ..where((t) => t.isSynced.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  /// Contar clientes pendientes de sincronizar
  Future<int> countClientesPendientes() async {
    final count = countAll();
    final query = selectOnly(clientesTable)
      ..addColumns([count])
      ..where(clientesTable.hasPendingChanges.equals(true));
    
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  // ==================== ESCRITURA ====================

  /// Insertar un nuevo cliente
  Future<int> insertCliente(ClientesTableCompanion cliente) {
    return into(clientesTable).insert(cliente);
  }

  /// Actualizar un cliente existente
  Future<bool> updateCliente(int id, ClientesTableCompanion cliente) async {
    final updatedRows = await (update(clientesTable)..where((t) => t.id.equals(id)))
        .write(cliente);
    return updatedRows > 0;
  }

  /// Eliminar físicamente un cliente (solo si no tiene odooId)
  Future<int> deleteCliente(int id) {
    return (delete(clientesTable)..where((t) => t.id.equals(id))).go();
  }

  /// Marcar cliente como eliminado (soft delete)
  Future<void> markAsDeleted(int id) {
    return (update(clientesTable)..where((t) => t.id.equals(id)))
        .write(const ClientesTableCompanion(
      isDeleted: Value(true),
      hasPendingChanges: Value(true),
      isSynced: Value(false),
    ));
  }

  /// Insertar o actualizar múltiples clientes (para sincronización masiva)
  Future<void> upsertClientes(List<ClientesTableCompanion> clientes) async {
    await batch((batch) {
      batch.insertAll(
        clientesTable,
        clientes,
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  /// Marcar cliente como sincronizado
  Future<void> markAsSynced(int id, int odooId) {
    return (update(clientesTable)..where((t) => t.id.equals(id)))
        .write(ClientesTableCompanion(
      odooId: Value(odooId),
      isSynced: const Value(true),
      hasPendingChanges: const Value(false),
      lastSyncAt: Value(DateTime.now()),
    ));
  }

  /// Actualizar última sincronización
  Future<void> updateLastSync(int id) {
    return (update(clientesTable)..where((t) => t.id.equals(id)))
        .write(ClientesTableCompanion(
      lastSyncAt: Value(DateTime.now()),
      isSynced: const Value(true),
    ));
  }

  // ==================== UTILIDADES ====================

  /// Limpiar clientes eliminados sincronizados (limpieza periódica)
  Future<int> cleanDeletedClientes() {
    return (delete(clientesTable)
          ..where((t) =>
              t.isDeleted.equals(true) &
              t.isSynced.equals(true)))
        .go();
  }

  /// Obtener estadísticas de sincronización
  Future<SyncStats> getSyncStats() async {
    final total = await (select(clientesTable)
          ..where((t) => t.isDeleted.equals(false)))
        .get()
        .then((list) => list.length);

    final sincronizados = await (select(clientesTable)
          ..where((t) =>
              t.isDeleted.equals(false) &
              t.isSynced.equals(true)))
        .get()
        .then((list) => list.length);

    final pendientes = await countClientesPendientes();

    return SyncStats(
      total: total,
      sincronizados: sincronizados,
      pendientes: pendientes,
    );
  }
}

// Modelo para estadísticas de sincronización
class SyncStats {
  final int total;
  final int sincronizados;
  final int pendientes;

  SyncStats({
    required this.total,
    required this.sincronizados,
    required this.pendientes,
  });

  int get noSincronizados => total - sincronizados;
  
  double get porcentajeSincronizado => 
      total > 0 ? (sincronizados / total * 100) : 0;

  @override
  String toString() => 
      'Total: $total, Sincronizados: $sincronizados, Pendientes: $pendientes';
}