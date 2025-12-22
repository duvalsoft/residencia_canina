// lib/src/data/tables/clientes_table.dart
import 'package:drift/drift.dart';

/// Tabla de clientes que sincroniza con res.partner de Odoo
@DataClassName('ClienteDb')
class ClientesTable extends Table {
  // ID local (autoincremental)
  IntColumn get id => integer().autoIncrement()();
  
  // ID de Odoo (puede ser null si aún no se ha sincronizado)
  IntColumn get odooId => integer().nullable()();
  
  // Datos básicos del cliente
  TextColumn get name => text()();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get mobile => text().nullable()();
  
  // Dirección
  TextColumn get street => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get zip => text().nullable()();
  IntColumn get countryId => integer().nullable()();
  
  // Control de sincronización
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  BoolColumn get hasPendingChanges => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  
  // Timestamps
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
  
  @override
  List<String> get customConstraints => [
    // El odooId debe ser único si existe
    'UNIQUE(odooId) WHERE odooId IS NOT NULL',
  ];
}