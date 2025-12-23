// lib/src/data/tables/clientes_table.dart
import 'package:drift/drift.dart';

/// Tabla de clientes que sincroniza con res.partner de Odoo
@DataClassName('ClienteDb')
class ClientesTable extends Table {
  // ID local (autoincremental)
  IntColumn get id => integer().autoIncrement()();
  
  // ID de Odoo (puede ser null si aún no se ha sincronizado)
  @JsonKey('odoo_id')
  IntColumn get odooId => integer().nullable().unique()();
  
  // Datos básicos del cliente
  TextColumn get name => text()();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get mobile => text().nullable()();
  
  // Dirección
  TextColumn get street => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get zip => text().nullable()();
  @JsonKey('country_id')
  IntColumn get countryId => integer().nullable()();
  
  // Control de sincronización
  @JsonKey('is_synced')
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  @JsonKey('has_pending_changes')
  BoolColumn get hasPendingChanges => boolean().withDefault(const Constant(false))();
  @JsonKey('is_deleted')
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  
  // Timestamps
    @JsonKey('created_at')
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
    @JsonKey('updated_at')
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
    @JsonKey('last_sync_at')
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
}
