import 'package:sqflite/sqflite.dart';
import 'package:exemplo/core/constants/database_constants.dart';
import 'package:exemplo/core/exceptions/database_exceptions.dart';
import 'package:exemplo/data/database/database_factory.dart';

class DatabaseProvider {
  DatabaseProvider(this._factory);

  final AppDatabaseFactory _factory;
  Database? _database;

  static const int _currentVersion = 1;

  Future<Database> getDatabase() async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      return await _factory.createDatabase(
        dbName: DatabaseConstants.dbName,
        version: _currentVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } catch (e) {
      throw DatabaseInitException('Failed to initialize database', e);
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      await db.execute('''
        CREATE TABLE ${DatabaseConstants.tableNome}(
          ${DatabaseConstants.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${DatabaseConstants.columnNome} TEXT NOT NULL,
          ${DatabaseConstants.columnIdade} INTEGER NOT NULL
        )
      ''');
    } catch (e) {
      throw DatabaseInitException('Failed to create database schema', e);
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    try {
      if (oldVersion < newVersion) {
        await db.execute('DROP TABLE IF EXISTS ${DatabaseConstants.tableNome}');
        await _onCreate(db, newVersion);
      }
    } catch (e) {
      throw DatabaseInitException(
        'Failed to upgrade database from v$oldVersion to v$newVersion',
        e,
      );
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  bool get isOpen => _database?.isOpen == true;
}
