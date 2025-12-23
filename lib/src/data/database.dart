import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/clientes_table.dart';
import 'tables/sync_log_table.dart';
import 'daos/clientes_dao.dart';
import 'daos/sync_log_dao.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    ClientesTable,
    SyncLogTable,
  ],
  daos: [
    ClientesDao,
    SyncLogDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      print('✅ Base de datos creada correctamente');
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Migraciones futuras aquí
      print('🔄 Migrando base de datos de v$from a v$to');
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    print('📱 Inicializando Drift para Android (SQLite nativo)');
    
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'odoo_rpc.sqlite'));
    
    print('📂 Base de datos en: ${file.path}');
    
    // Usando NativeDatabase con archivo en background
    return NativeDatabase.createInBackground(file);
  });
}