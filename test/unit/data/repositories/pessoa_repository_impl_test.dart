import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:exemplo/domain/models/pessoa.dart';
import 'package:exemplo/data/repositories/pessoa_repository_impl.dart';
import 'package:exemplo/data/daos/pessoa_dao.dart';
import 'package:exemplo/data/dtos/pessoa_dto.dart';
import 'package:exemplo/core/exceptions/database_exceptions.dart';

@GenerateNiceMocks([MockSpec<PessoaDao>()])
import 'pessoa_repository_impl_test.mocks.dart';

void main() {
  group('PessoaRepositoryImpl', () {
    late MockPessoaDao mockDao;
    late PessoaRepositoryImpl repository;

    setUp(() {
      mockDao = MockPessoaDao();
      repository = PessoaRepositoryImpl(mockDao);
    });

    group('create', () {
      test(
        'should return success with id when dao creates successfully',
        () async {
          const pessoa = Pessoa(nome: 'João', idade: 30);
          when(mockDao.create(any)).thenAnswer((_) async => 1);

          final result = await repository.create(pessoa);

          expect(result.isSuccess, isTrue);
          expect(result.data, equals(1));
          verify(mockDao.create(any)).called(1);
        },
      );

      test('should return failure when validation fails', () async {
        const pessoa = Pessoa(nome: '', idade: 30); // Invalid nome

        final result = await repository.create(pessoa);

        expect(result.isFailure, isTrue);
        expect(result.message, contains('Nome não pode estar vazio'));
        verifyNever(mockDao.create(any));
      });

      test('should return failure when dao throws DatabaseException', () async {
        const pessoa = Pessoa(nome: 'João', idade: 30);
        when(
          mockDao.create(any),
        ).thenThrow(const DatabaseOperationException('Database error'));

        final result = await repository.create(pessoa);

        expect(result.isFailure, isTrue);
        expect(result.message, equals('Database error'));
      });

      test(
        'should return failure when dao throws unexpected exception',
        () async {
          const pessoa = Pessoa(nome: 'João', idade: 30);
          when(mockDao.create(any)).thenThrow(Exception('Unexpected error'));

          final result = await repository.create(pessoa);

          expect(result.isFailure, isTrue);
          expect(result.message, contains('Erro inesperado ao criar pessoa'));
        },
      );
    });

    group('getAll', () {
      test(
        'should return success with list of pessoas when dao succeeds',
        () async {
          final dtos = [
            const PessoaDto(id: 1, nome: 'João', idade: 30),
            const PessoaDto(id: 2, nome: 'Maria', idade: 25),
          ];
          when(mockDao.findAll()).thenAnswer((_) async => dtos);

          final result = await repository.getAll();

          expect(result.isSuccess, isTrue);
          expect(result.data!.length, equals(2));
          expect(result.data![0].nome, equals('João'));
          expect(result.data![1].nome, equals('Maria'));
        },
      );

      test('should return empty list when dao returns empty', () async {
        when(mockDao.findAll()).thenAnswer((_) async => []);

        final result = await repository.getAll();

        expect(result.isSuccess, isTrue);
        expect(result.data!.isEmpty, isTrue);
      });

      test('should return failure when dao throws exception', () async {
        when(
          mockDao.findAll(),
        ).thenThrow(const DatabaseOperationException('Database error'));

        final result = await repository.getAll();

        expect(result.isFailure, isTrue);
        expect(result.message, equals('Database error'));
      });
    });

    group('getById', () {
      test('should return success with pessoa when found', () async {
        const dto = PessoaDto(id: 1, nome: 'João', idade: 30);
        when(mockDao.findById(1)).thenAnswer((_) async => dto);

        final result = await repository.getById(1);

        expect(result.isSuccess, isTrue);
        expect(result.data!.nome, equals('João'));
        expect(result.data!.idade, equals(30));
      });

      test('should return success with null when not found', () async {
        when(mockDao.findById(999)).thenAnswer((_) async => null);

        final result = await repository.getById(999);

        expect(result.isSuccess, isTrue);
        expect(result.data, isNull);
      });

      test('should return failure when dao throws exception', () async {
        when(
          mockDao.findById(1),
        ).thenThrow(const DatabaseOperationException('Database error'));

        final result = await repository.getById(1);

        expect(result.isFailure, isTrue);
        expect(result.message, equals('Database error'));
      });
    });

    group('update', () {
      test(
        'should return success with affected rows when update succeeds',
        () async {
          const pessoa = Pessoa(id: 1, nome: 'João Silva', idade: 31);
          when(mockDao.update(any)).thenAnswer((_) async => 1);

          final result = await repository.update(pessoa);

          expect(result.isSuccess, isTrue);
          expect(result.data, equals(1));
        },
      );

      test('should return failure when pessoa has no id', () async {
        const pessoa = Pessoa(nome: 'João', idade: 30);

        final result = await repository.update(pessoa);

        expect(result.isFailure, isTrue);
        expect(
          result.message,
          contains('Não é possível atualizar pessoa sem ID'),
        );
        verifyNever(mockDao.update(any));
      });

      test('should return failure when validation fails', () async {
        const pessoa = Pessoa(id: 1, nome: '', idade: 30);

        final result = await repository.update(pessoa);

        expect(result.isFailure, isTrue);
        expect(result.message, contains('Nome não pode estar vazio'));
        verifyNever(mockDao.update(any));
      });

      test('should return failure when no rows affected', () async {
        const pessoa = Pessoa(id: 999, nome: 'João', idade: 30);
        when(mockDao.update(any)).thenAnswer((_) async => 0);

        final result = await repository.update(pessoa);

        expect(result.isFailure, isTrue);
        expect(result.message, contains('Pessoa com ID 999 não encontrada'));
      });
    });

    group('delete', () {
      test(
        'should return success with affected rows when delete succeeds',
        () async {
          when(mockDao.deleteById(1)).thenAnswer((_) async => 1);

          final result = await repository.delete(1);

          expect(result.isSuccess, isTrue);
          expect(result.data, equals(1));
        },
      );

      test('should return failure when no rows affected', () async {
        when(mockDao.deleteById(999)).thenAnswer((_) async => 0);

        final result = await repository.delete(999);

        expect(result.isFailure, isTrue);
        expect(result.message, contains('Pessoa com ID 999 não encontrada'));
      });

      test('should return failure when dao throws exception', () async {
        when(
          mockDao.deleteById(1),
        ).thenThrow(const DatabaseOperationException('Database error'));

        final result = await repository.delete(1);

        expect(result.isFailure, isTrue);
        expect(result.message, equals('Database error'));
      });
    });

    group('exists', () {
      test('should return success with true when pessoa exists', () async {
        when(mockDao.existsById(1)).thenAnswer((_) async => true);

        final result = await repository.exists(1);

        expect(result.isSuccess, isTrue);
        expect(result.data, isTrue);
      });

      test(
        'should return success with false when pessoa does not exist',
        () async {
          when(mockDao.existsById(999)).thenAnswer((_) async => false);

          final result = await repository.exists(999);

          expect(result.isSuccess, isTrue);
          expect(result.data, isFalse);
        },
      );

      test('should return failure when dao throws exception', () async {
        when(
          mockDao.existsById(1),
        ).thenThrow(const DatabaseOperationException('Database error'));

        final result = await repository.exists(1);

        expect(result.isFailure, isTrue);
        expect(result.message, equals('Database error'));
      });
    });
  });
}
