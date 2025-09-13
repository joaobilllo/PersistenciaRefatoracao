import 'package:sqflite/sqflite.dart';

abstract class AppDatabaseFactory {
  Future<Database> createDatabase({
    required String dbName,
    required int version,
    required Future<void> Function(Database db, int version) onCreate,
    Future<void> Function(Database db, int oldVersion, int newVersion)?
    onUpgrade,
  });

  Future<String?> getDatabasePath(String dbName);
}
