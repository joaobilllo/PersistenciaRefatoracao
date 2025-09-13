import 'package:exemplo/core/result/result.dart';
import 'package:exemplo/core/exceptions/database_exceptions.dart';
import 'package:exemplo/domain/models/pessoa.dart';
import 'package:exemplo/domain/repositories/pessoa_repository.dart';
import 'package:exemplo/data/daos/pessoa_dao.dart';
import 'package:exemplo/data/dtos/pessoa_dto.dart';

class PessoaRepositoryImpl implements PessoaRepository {
  const PessoaRepositoryImpl(this._dao);

  final PessoaDao _dao;

  @override
  Future<Result<int>> create(Pessoa pessoa) async {
    try {
      pessoa.validate();
      final dto = PessoaDto.fromDomain(pessoa);
      final id = await _dao.create(dto);
      return Result.success(id);
    } on ValidationException catch (e) {
      return Result.failure(e.message, e);
    } on DatabaseException catch (e) {
      return Result.failure(e.message, e);
    } catch (e) {
      return Result.failure(
        'Erro inesperado ao criar pessoa: $e',
        e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  @override
  Future<Result<List<Pessoa>>> getAll() async {
    try {
      final dtos = await _dao.findAll();
      final pessoas = dtos.map((dto) => dto.toDomain()).toList();
      return Result.success(pessoas);
    } on DatabaseException catch (e) {
      return Result.failure(e.message, e);
    } catch (e) {
      return Result.failure(
        'Erro inesperado ao buscar pessoas: $e',
        e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  @override
  Future<Result<Pessoa?>> getById(int id) async {
    try {
      final dto = await _dao.findById(id);
      final pessoa = dto?.toDomain();
      return Result.success(pessoa);
    } on DatabaseException catch (e) {
      return Result.failure(e.message, e);
    } catch (e) {
      return Result.failure(
        'Erro inesperado ao buscar pessoa: $e',
        e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  @override
  Future<Result<int>> update(Pessoa pessoa) async {
    try {
      pessoa.validate();
      final dto = PessoaDto.fromDomain(pessoa);
      final rowsAffected = await _dao.update(dto);
      return Result.success(rowsAffected);
    } on ValidationException catch (e) {
      return Result.failure(e.message, e);
    } on DatabaseException catch (e) {
      return Result.failure(e.message, e);
    } catch (e) {
      return Result.failure(
        'Erro inesperado ao atualizar pessoa: $e',
        e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  @override
  Future<Result<int>> delete(int id) async {
    try {
      final rowsAffected = await _dao.deleteById(id);
      return Result.success(rowsAffected);
    } on DatabaseException catch (e) {
      return Result.failure(e.message, e);
    } catch (e) {
      return Result.failure(
        'Erro inesperado ao deletar pessoa: $e',
        e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  @override
  Future<Result<bool>> exists(int id) async {
    try {
      final exists = await _dao.existsById(id);
      return Result.success(exists);
    } on DatabaseException catch (e) {
      return Result.failure(e.message, e);
    } catch (e) {
      return Result.failure(
        'Erro inesperado ao verificar existência: $e',
        e is Exception ? e : Exception(e.toString()),
      );
    }
  }
}
