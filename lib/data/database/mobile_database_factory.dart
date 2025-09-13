import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:exemplo/data/database/database_factory.dart';

class MobileDatabaseFactory implements AppDatabaseFactory {
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
