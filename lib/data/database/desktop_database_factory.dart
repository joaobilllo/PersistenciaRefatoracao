import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;
import 'package:exemplo/data/database/database_factory.dart';

class DesktopDatabaseFactory implements AppDatabaseFactory {
  DesktopDatabaseFactory() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  @override
  Future<Database> createDatabase({
    required String dbName,
    required int version,
    required Future<void> Function(Database db, int version) onCreate,
    Future<void> Function(Database db, int oldVersion, int newVersion)?
    onUpgrade,
  }) async {
    final dbDir = await getDatabasesPath();
    final path = p.join(dbDir, dbName);

    return await openDatabase(
      path,
      version: version,
      onCreate: onCreate,
      onUpgrade: onUpgrade,
    );
  }

  @override
  Future<String?> getDatabasePath(String dbName) async {
    final dbDir = await getDatabasesPath();
    return p.join(dbDir, dbName);
  }
}
