import 'package:sqflite/sqflite.dart';
import 'package:exemplo/core/constants/database_constants.dart';
import 'package:exemplo/core/exceptions/database_exceptions.dart';
import 'package:exemplo/data/dtos/pessoa_dto.dart';

class PessoaDao {
  const PessoaDao(this._database);

  final Database _database;

  Future<int> create(PessoaDto dto) async {
    try {
      return await _database.insert(
        DatabaseConstants.tableNome,
        dto.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } catch (e) {
      throw DatabaseOperationException(
        'Failed to create pessoa: ${dto.nome}',
        e,
      );
    }
  }

  Future<List<PessoaDto>> findAll() async {
    try {
      final maps = await _database.query(
        DatabaseConstants.tableNome,
        orderBy: '${DatabaseConstants.columnId} DESC',
      );
      return maps.map((map) => PessoaDto.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseOperationException('Failed to fetch all pessoas', e);
    }
  }

  Future<PessoaDto?> findById(int id) async {
    try {
      final result = await _database.query(
        DatabaseConstants.tableNome,
        where: '${DatabaseConstants.columnId} = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (result.isEmpty) return null;
      return PessoaDto.fromMap(result.first);
    } catch (e) {
      throw DatabaseOperationException('Failed to find pessoa with id: $id', e);
    }
  }

  Future<int> update(PessoaDto dto) async {
    if (dto.id == null) {
      throw const ValidationException('Cannot update pessoa without ID');
    }

    try {
      return await _database.update(
        DatabaseConstants.tableNome,
        dto.toMap(),
        where: '${DatabaseConstants.columnId} = ?',
        whereArgs: [dto.id],
      );
    } catch (e) {
      throw DatabaseOperationException(
        'Failed to update pessoa with id: ${dto.id}',
        e,
      );
    }
  }

  Future<int> deleteById(int id) async {
    try {
      return await _database.delete(
        DatabaseConstants.tableNome,
        where: '${DatabaseConstants.columnId} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw DatabaseOperationException(
        'Failed to delete pessoa with id: $id',
        e,
      );
    }
  }

  Future<bool> existsById(int id) async {
    try {
      final result = await _database.query(
        DatabaseConstants.tableNome,
        columns: [DatabaseConstants.columnId],
        where: '${DatabaseConstants.columnId} = ?',
        whereArgs: [id],
        limit: 1,
      );
      return result.isNotEmpty;
    } catch (e) {
      throw DatabaseOperationException(
        'Failed to check if pessoa exists with id: $id',
        e,
      );
    }
  }

  Future<int> count() async {
    try {
      final result = await _database.rawQuery(
        'SELECT COUNT(*) FROM ${DatabaseConstants.tableNome}',
      );
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      throw DatabaseOperationException('Failed to count pessoas', e);
    }
  }
}
