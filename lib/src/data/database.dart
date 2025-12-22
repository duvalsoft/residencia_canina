// lib/src/data/database.dart
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
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Futuras migraciones aquí
          // Ejemplo para versión 2:
          // if (from < 2) {
          //   await m.addColumn(clientesTable, clientesTable.nuevaColumna);
          // }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}