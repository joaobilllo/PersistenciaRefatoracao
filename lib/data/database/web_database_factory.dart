import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:exemplo/data/database/database_factory.dart';

class WebDatabaseFactory implements AppDatabaseFactory {
  WebDatabaseFactory() {
    databaseFactory = databaseFactoryFfiWeb;
  }

  @override
  Future<Database> createDatabase({
    required String dbName,
    required int version,
    required Future<void> Function(Database db, int version) onCreate,
    Future<void> Function(Database db, int oldVersion, int newVersion)?
    onUpgrade,
  }) async {
    return await databaseFactory.openDatabase(
      dbName,
      options: OpenDatabaseOptions(
        version: version,
        onCreate: onCreate,
        onUpgrade: onUpgrade,
      ),
    );
  }

  @override
  Future<String?> getDatabasePath(String dbName) async {
    return null;
  }
}
