// lib/src/repositories/base_repository.dart
import '../services/odoo_service.dart';
import '../data/database.dart';

/// Clase base abstracta para todos los repositorios
/// Proporciona funcionalidad común de sincronización
abstract class BaseRepository<T, TCompanion> {
  final AppDatabase database;
  final OdooService odooService;

  BaseRepository({
    required this.database,
    required this.odooService,
  });

  /// Nombre del modelo en Odoo (ej: 'res.partner')
  String get odooModel;

  /// Tipo de entidad para logs (ej: 'cliente')
  String get entityType;

  /// Campos a recuperar de Odoo
  List<String> get odooFields;

  /// Convertir datos de Odoo a companion local
  TCompanion fromOdooData(Map<String, dynamic> odooData);

  /// Convertir entidad local a datos de Odoo
  Map<String, dynamic> toOdooData(T entity);

  /// Obtener ID de Odoo de la entidad
  int? getOdooId(T entity);

  /// Obtener ID local de la entidad
  int getLocalId(T entity);

  /// Stream de todas las entidades
  Stream<List<T>> watchAll();

  /// Obtener entidad por ID local
  Future<T?> getById(int id);

  /// Crear entidad local
  Future<int> create(TCompanion companion);

  /// Actualizar entidad local
  Future<bool> update(T entity);

  /// Eliminar entidad local (soft delete)
  Future<bool> delete(int id);

  /// Sincronización completa (pull + push)
  Future<SyncResult> sync() async {
    final result = SyncResult();

    try {
      // 1. Push: Subir cambios locales a Odoo
      result.pushed = await _pushChanges();

      // 2. Pull: Descargar datos de Odoo
      result.pulled = await _pullFromOdoo();

      result.success = true;
    } catch (e) {
      result.success = false;
      result.error = e.toString();
    }

    return result;
  }

  /// Subir cambios locales a Odoo
  Future<int> _pushChanges() async {
    final pending = await _getPendingSync();
    int count = 0;

    for (final entity in pending) {
      try {
        final odooId = getOdooId(entity);
        final data = toOdooData(entity);

        if (odooId == null) {
          // Crear en Odoo
          final newId = await _createInOdoo(data);
          await _markAsSynced(getLocalId(entity), newId);
        } else {
          // Actualizar en Odoo
          await _updateInOdoo(odooId, data);
          await _markAsSynced(getLocalId(entity), odooId);
        }

        await _logSync(getLocalId(entity), 'push', 'success');
        count++;
      } catch (e) {
        await _logSync(getLocalId(entity), 'push', 'error', e.toString());
      }
    }

    return count;
  }

  /// Descargar datos desde Odoo
  Future<int> _pullFromOdoo() async {
    try {
      final records = await odooService.searchRead(
        model: odooModel,
        domain: [],
        fields: odooFields,
        limit: 1000,
      );

      int count = 0;
      for (final record in records) {
        await _upsertFromOdoo(record as Map<String, dynamic>);
        count++;
      }

      return count;
    } catch (e) {
      rethrow;
    }
  }

  /// Crear registro en Odoo
  Future<int> _createInOdoo(Map<String, dynamic> data) async {
    final result = await odooService.executeKw(
      odooModel,
      'create',
      [data],
    );
    return result as int;
  }

  /// Actualizar registro en Odoo
  Future<void> _updateInOdoo(int odooId, Map<String, dynamic> data) async {
    await odooService.executeKw(
      odooModel,
      'write',
      [
        [odooId],
        data
      ],
    );
  }

  // Métodos abstractos que deben implementar las subclases

  Future<List<T>> _getPendingSync();
  Future<void> _markAsSynced(int localId, int odooId);
  Future<void> _upsertFromOdoo(Map<String, dynamic> odooData);
  Future<void> _logSync(int entityId, String operation, String status,
      [String? error]);
}

/// Resultado de sincronización
class SyncResult {
  bool success = false;
  int pushed = 0;
  int pulled = 0;
  String? error;

  @override
  String toString() {
    if (!success) return 'Error: $error';
    return 'Sync completado: $pushed enviados, $pulled recibidos';
  }
}