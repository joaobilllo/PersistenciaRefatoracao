import 'package:flutter_test/flutter_test.dart';
import 'package:exemplo/domain/models/pessoa.dart';
import 'package:exemplo/core/exceptions/database_exceptions.dart';

void main() {
  group('Pessoa', () {
    test('should create pessoa with valid data', () {
      const pessoa = Pessoa(id: 1, nome: 'João', idade: 30);

      expect(pessoa.id, equals(1));
      expect(pessoa.nome, equals('João'));
      expect(pessoa.idade, equals(30));
    });

    test('should create pessoa without id', () {
      const pessoa = Pessoa(nome: 'Maria', idade: 25);

      expect(pessoa.id, isNull);
      expect(pessoa.nome, equals('Maria'));
      expect(pessoa.idade, equals(25));
    });

    test('should create copy with modified fields', () {
      const original = Pessoa(id: 1, nome: 'João', idade: 30);
      final copy = original.copyWith(nome: 'João Silva', idade: 31);

      expect(copy.id, equals(1));
      expect(copy.nome, equals('João Silva'));
      expect(copy.idade, equals(31));
    });

    test('should create copy without modifying original', () {
      const original = Pessoa(id: 1, nome: 'João', idade: 30);
      final copy = original.copyWith(nome: 'João Silva');

      expect(original.nome, equals('João'));
      expect(copy.nome, equals('João Silva'));
      expect(original.idade, equals(copy.idade));
    });

    test('should validate successfully with valid data', () {
      const pessoa = Pessoa(nome: 'João', idade: 30);

      expect(() => pessoa.validate(), returnsNormally);
    });

    test('should throw ValidationException for empty nome', () {
      const pessoa = Pessoa(nome: '', idade: 30);

      expect(() => pessoa.validate(), throwsA(isA<ValidationException>()));
    });

    test('should throw ValidationException for short nome', () {
      const pessoa = Pessoa(nome: 'A', idade: 30);

      expect(() => pessoa.validate(), throwsA(isA<ValidationException>()));
    });

    test('should throw ValidationException for very long nome', () {
      final longName = 'A' * 101;
      final pessoa = Pessoa(nome: longName, idade: 30);

      expect(() => pessoa.validate(), throwsA(isA<ValidationException>()));
    });

    test('should throw ValidationException for negative idade', () {
      const pessoa = Pessoa(nome: 'João', idade: -1);

      expect(() => pessoa.validate(), throwsA(isA<ValidationException>()));
    });

    test('should throw ValidationException for idade over 150', () {
      const pessoa = Pessoa(nome: 'João', idade: 151);

      expect(() => pessoa.validate(), throwsA(isA<ValidationException>()));
    });

    test('should accept edge case ages', () {
      const pessoa1 = Pessoa(nome: 'Bebê', idade: 0);
      const pessoa2 = Pessoa(nome: 'Muito Idoso', idade: 150);

      expect(() => pessoa1.validate(), returnsNormally);
      expect(() => pessoa2.validate(), returnsNormally);
    });

    test('should be equal when all fields match', () {
      const pessoa1 = Pessoa(id: 1, nome: 'João', idade: 30);
      const pessoa2 = Pessoa(id: 1, nome: 'João', idade: 30);

      expect(pessoa1, equals(pessoa2));
      expect(pessoa1.hashCode, equals(pessoa2.hashCode));
    });

    test('should not be equal when fields differ', () {
      const pessoa1 = Pessoa(id: 1, nome: 'João', idade: 30);
      const pessoa2 = Pessoa(id: 2, nome: 'João', idade: 30);

      expect(pessoa1, isNot(equals(pessoa2)));
    });

    test('toString should contain all field values', () {
      const pessoa = Pessoa(id: 1, nome: 'João', idade: 30);
      final string = pessoa.toString();

      expect(string, contains('1'));
      expect(string, contains('João'));
      expect(string, contains('30'));
    });
  });
}
