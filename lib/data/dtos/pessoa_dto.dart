import 'package:exemplo/core/constants/database_constants.dart';
import 'package:exemplo/domain/models/pessoa.dart';

class PessoaDto {
  const PessoaDto({this.id, required this.nome, required this.idade});

  final int? id;
  final String nome;
  final int idade;

  factory PessoaDto.fromDomain(Pessoa pessoa) {
    return PessoaDto(id: pessoa.id, nome: pessoa.nome, idade: pessoa.idade);
  }

  factory PessoaDto.fromMap(Map<String, dynamic> map) {
    return PessoaDto(
      id: map[DatabaseConstants.columnId] as int?,
      nome: map[DatabaseConstants.columnNome] as String,
      idade: (map[DatabaseConstants.columnIdade] as num).toInt(),
    );
  }

  Pessoa toDomain() {
    return Pessoa(id: id, nome: nome, idade: idade);
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      DatabaseConstants.columnNome: nome,
      DatabaseConstants.columnIdade: idade,
    };
    if (id != null) {
      map[DatabaseConstants.columnId] = id;
    }
    return map;
  }

  @override
  String toString() => 'PessoaDto(id: $id, nome: $nome, idade: $idade)';
}
