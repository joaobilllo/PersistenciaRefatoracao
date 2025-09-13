import 'package:exemplo/core/result/result.dart';
import 'package:exemplo/domain/models/pessoa.dart';

abstract class PessoaRepository {
  Future<Result<int>> create(Pessoa pessoa);
  Future<Result<List<Pessoa>>> getAll();
  Future<Result<Pessoa?>> getById(int id);
  Future<Result<int>> update(Pessoa pessoa);
  Future<Result<int>> delete(int id);
  Future<Result<bool>> exists(int id);
}
