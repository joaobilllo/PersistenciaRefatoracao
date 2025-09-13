import 'package:exemplo/core/exceptions/database_exceptions.dart';

class Pessoa {
  const Pessoa({this.id, required this.nome, required this.idade});

  final int? id;
  final String nome;
  final int idade;

  Pessoa copyWith({int? id, String? nome, int? idade}) {
    return Pessoa(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      idade: idade ?? this.idade,
    );
  }

  void validate() {
    if (nome.trim().isEmpty) {
      throw const ValidationException('Nome não pode estar vazio');
    }
    if (nome.trim().length < 2) {
      throw const ValidationException('Nome deve ter pelo menos 2 caracteres');
    }
    if (nome.trim().length > 100) {
      throw const ValidationException(
        'Nome não pode ter mais de 100 caracteres',
      );
    }
    if (idade < 0 || idade > 150) {
      throw const ValidationException('Idade deve estar entre 0 e 150 anos');
    }
  }

  @override
  String toString() => 'Pessoa(id: $id, nome: $nome, idade: $idade)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Pessoa &&
        other.id == id &&
        other.nome == nome &&
        other.idade == idade;
  }

  @override
  int get hashCode => Object.hash(id, nome, idade);
}
