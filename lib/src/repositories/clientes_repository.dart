// lib/src/repositories/clientes_repository.dart
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../data/database.dart';
import '../services/odoo_service.dart';

/// Repository que implementa el patrón offline-first para clientes
/// 
/// Prioridad: 
/// 1. Lee primero de la BD local (offline)
/// 2. Sincroniza con Odoo en segundo plano
/// 3. Maneja conflictos y cambios pendientes
class ClientesRepository {
  final AppDatabase _db;
  final OdooService _odooService;

  ClientesRepository(this._db, this._odooService);

  // ==================== LECTURA (Offline First) ====================

  /// Obtiene todos los clientes desde la BD local
  /// Esta es la fuente de verdad para la UI
  Stream<List<ClienteDb>> watchAllClientes() {
    return _db.clientesDao.watchAllClientes();
  }

  /// Obtiene un cliente específico por ID local
  Future<ClienteDb?> getClienteById(int id) {
    return _db.clientesDao.getClienteById(id);
  }

  /// Obtiene un cliente por su ID de Odoo
  Future<ClienteDb?> getClienteByOdooId(int odooId) {
    return _db.clientesDao.getClienteByOdooId(odooId);
  }

  /// Busca clientes por nombre (búsqueda local)
  Future<List<ClienteDb>> searchClientes(String query) {
    return _db.clientesDao.searchClientes(query);
  }

  /// Obtiene clientes con cambios pendientes de sincronizar
  Future<List<ClienteDb>> getClientesPendientes() {
    return _db.clientesDao.getClientesPendientes();
  }

  // ==================== SINCRONIZACIÓN ====================

  /// Sincroniza clientes desde Odoo a la BD local
  /// Este método se ejecuta en segundo plano
  Future<SyncResult> syncFromOdoo({
    int limit = 100,
    int offset = 0,
  }) async {
    try {
      // 1. Obtener clientes desde Odoo
      final odooClientes = await _odooService.searchRead(
        model: 'res.partner',
        domain: [['customer_rank', '>', 0]], // Solo clientes
        fields: ['name', 'email', 'phone', 'mobile', 'street', 'city', 'zip', 'country_id'],
        limit: limit,
        offset: offset,
      );

      int inserted = 0;
      int updated = 0;
      int errors = 0;

      // 2. Insertar o actualizar cada cliente en la BD local
      for (var odooData in odooClientes) {
        try {
          final odooId = odooData['id'] as int;
          final existingCliente = await getClienteByOdooId(odooId);

          final clienteCompanion = ClientesTableCompanion(
            odooId: Value(odooId),
            name: Value(odooData['name'] as String),
            email: Value(odooData['email'] as String?),
            phone: Value(odooData['phone'] as String?),
            mobile: Value(odooData['mobile'] as String?),
            street: Value(odooData['street'] as String?),
            city: Value(odooData['city'] as String?),
            zip: Value(odooData['zip'] as String?),
            countryId: Value(odooData['country_id'] != null && odooData['country_id'] is List
                ? (odooData['country_id'] as List).first as int
                : null),
            isSynced: const Value(true),
            lastSyncAt: Value(DateTime.now()),
          );

          if (existingCliente == null) {
            // Insertar nuevo
            await _db.clientesDao.insertCliente(clienteCompanion);
            inserted++;
          } else {
            // Actualizar existente (solo si no hay cambios locales pendientes)
            if (!existingCliente.hasPendingChanges) {
              await _db.clientesDao.updateCliente(
                existingCliente.id,
                clienteCompanion,
              );
              updated++;
            }
          }
        } catch (e) {
          errors++;
          debugPrint('Error sincronizando cliente: $e');
        }
      }

      return SyncResult(
        success: true,
        inserted: inserted,
        updated: updated,
        errors: errors,
        total: odooClientes.length,
      );
    } catch (e) {
      return SyncResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  /// Sincroniza cambios locales pendientes hacia Odoo
  Future<SyncResult> syncToOdoo() async {
    try {
      final clientesPendientes = await getClientesPendientes();
      
      int success = 0;
      int errors = 0;

      for (var cliente in clientesPendientes) {
        try {
          if (cliente.odooId == null) {
            // Crear en Odoo
            final newOdooId = await _createClienteInOdoo(cliente);
            
            // Actualizar el cliente local con el ID de Odoo
            await _db.clientesDao.updateCliente(
              cliente.id,
              ClientesTableCompanion(
                odooId: Value(newOdooId),
                isSynced: const Value(true),
                hasPendingChanges: const Value(false),
                lastSyncAt: Value(DateTime.now()),
              ),
            );
          } else {
            // Actualizar en Odoo
            await _updateClienteInOdoo(cliente);
            
            // Marcar como sincronizado
            await _db.clientesDao.updateCliente(
              cliente.id,
              ClientesTableCompanion(
                isSynced: const Value(true),
                hasPendingChanges: const Value(false),
                lastSyncAt: Value(DateTime.now()),
              ),
            );
          }

          // Registrar en sync_log
          await _db.syncLogDao.createLog(
            entityType: 'cliente',
            entityId: cliente.id,
            operation: cliente.odooId == null ? 'create' : 'update',
            status: 'success',
          );

          success++;
        } catch (e) {
          errors++;
          
          // Registrar error en sync_log
          await _db.syncLogDao.createLog(
            entityType: 'cliente',
            entityId: cliente.id,
            operation: cliente.odooId == null ? 'create' : 'update',
            status: 'error',
            errorMessage: e.toString(),
          );
        }
      }

      return SyncResult(
        success: true,
        inserted: success,
        errors: errors,
        total: clientesPendientes.length,
      );
    } catch (e) {
      return SyncResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  // ==================== CRUD LOCAL ====================

  /// Crea un nuevo cliente localmente (se sincronizará después)
  Future<int> createCliente({
    required String name,
    String? email,
    String? phone,
    String? mobile,
    String? street,
    String? city,
    String? zip,
    int? countryId,
  }) async {
    final companion = ClientesTableCompanion.insert(
      name: name,
      email: Value(email),
      phone: Value(phone),
      mobile: Value(mobile),
      street: Value(street),
      city: Value(city),
      zip: Value(zip),
      countryId: Value(countryId),
      isSynced: const Value(false),
      hasPendingChanges: const Value(true),
    );

    final id = await _db.clientesDao.insertCliente(companion);

    // Registrar en sync_log
    await _db.syncLogDao.createLog(
      entityType: 'cliente',
      entityId: id,
      operation: 'create',
      status: 'pending',
    );

    return id;
  }

  /// Actualiza un cliente localmente (se sincronizará después)
  Future<void> updateCliente(
    int id, {
    String? name,
    String? email,
    String? phone,
    String? mobile,
    String? street,
    String? city,
    String? zip,
    int? countryId,
  }) async {
    final companion = ClientesTableCompanion(
      name: Value.absentIfNull(name),
      email: Value(email),
      phone: Value(phone),
      mobile: Value(mobile),
      street: Value(street),
      city: Value(city),
      zip: Value(zip),
      countryId: Value(countryId),
      isSynced: const Value(false),
      hasPendingChanges: const Value(true),
      updatedAt: Value(DateTime.now()),
    );

    await _db.clientesDao.updateCliente(id, companion);

    // Registrar en sync_log
    await _db.syncLogDao.createLog(
      entityType: 'cliente',
      entityId: id,
      operation: 'update',
      status: 'pending',
    );
  }

  /// Elimina un cliente localmente (se sincronizará después)
  Future<void> deleteCliente(int id) async {
    final cliente = await getClienteById(id);
    if (cliente == null) return;

    if (cliente.odooId != null) {
      // Marcar como eliminado para sincronizar después
      await _db.clientesDao.updateCliente(
        id,
        const ClientesTableCompanion(
          isDeleted: Value(true),
          isSynced: Value(false),
          hasPendingChanges: Value(true),
        ),
      );

      // Registrar en sync_log
      await _db.syncLogDao.createLog(
        entityType: 'cliente',
        entityId: id,
        operation: 'delete',
        status: 'pending',
      );
    } else {
      // Si no tiene odooId, eliminar directamente
      await _db.clientesDao.deleteCliente(id);
    }
  }

  // ==================== MÉTODOS PRIVADOS ====================

  Future<int> _createClienteInOdoo(ClienteDb cliente) async {
    final result = await _odooService.executeKw(
      'res.partner',
      'create',
      [
        {
          'name': cliente.name,
          'email': cliente.email,
          'phone': cliente.phone,
          'mobile': cliente.mobile,
          'street': cliente.street,
          'city': cliente.city,
          'zip': cliente.zip,
          'country_id': cliente.countryId,
          'customer_rank': 1,
        }
      ],
    );

    return result as int;
  }

  Future<void> _updateClienteInOdoo(ClienteDb cliente) async {
    await _odooService.executeKw(
      'res.partner',
      'write',
      [
        [cliente.odooId],
        {
          'name': cliente.name,
          'email': cliente.email,
          'phone': cliente.phone,
          'mobile': cliente.mobile,
          'street': cliente.street,
          'city': cliente.city,
          'zip': cliente.zip,
          'country_id': cliente.countryId,
        }
      ],
    );
  }
}

// ==================== MODELO DE RESULTADO ====================

class SyncResult {
  final bool success;
  final int inserted;
  final int updated;
  final int errors;
  final int total;
  final String? error;

  SyncResult({
    required this.success,
    this.inserted = 0,
    this.updated = 0,
    this.errors = 0,
    this.total = 0,
    this.error,
  });

  @override
  String toString() {
    if (!success) return 'Error: $error';
    return 'Sync: $inserted insertados, $updated actualizados, $errors errores de $total total';
  }
}