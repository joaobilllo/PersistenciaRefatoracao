import 'package:flutter_test/flutter_test.dart';
import 'package:exemplo/core/result/result.dart';

void main() {
  group('Result', () {
    group('Success', () {
      test('should create successful result', () {
        final result = Result<String>.success('test data');

        expect(result.isSuccess, isTrue);
        expect(result.isFailure, isFalse);
        expect(result.data, equals('test data'));
        expect(result.message, isNull);
        expect(result.exception, isNull);
      });

      test('should execute success callback in when', () {
        final result = Result<String>.success('test data');

        final output = result.when(
          success: (data) => 'Success: $data',
          failure: (message, exception) => 'Failure: $message',
        );

        expect(output, equals('Success: test data'));
      });

      test('should map data successfully', () {
        final result = Result<String>.success('test');

        final mapped = result.map<int>((data) => data.length);

        expect(mapped.isSuccess, isTrue);
        expect(mapped.data, equals(4));
      });

      test('should handle mapping exception', () {
        final result = Result<String>.success('test');

        final mapped = result.map<int>(
          (data) => throw Exception('mapping error'),
        );

        expect(mapped.isFailure, isTrue);
        expect(mapped.message, contains('Transformation failed'));
      });

      test('should be equal when data is equal', () {
        const result1 = Success('test');
        const result2 = Success('test');

        expect(result1, equals(result2));
        expect(result1.hashCode, equals(result2.hashCode));
      });

      test('should have proper toString', () {
        const result = Success('test data');

        expect(result.toString(), equals('Success(data: test data)'));
      });
    });

    group('Failure', () {
      test('should create failed result', () {
        final result = Result<String>.failure('error message');

        expect(result.isSuccess, isFalse);
        expect(result.isFailure, isTrue);
        expect(result.data, isNull);
        expect(result.message, equals('error message'));
        expect(result.exception, isNull);
      });

      test('should create failed result with exception', () {
        final exception = Exception('test exception');
        final result = Result<String>.failure('error message', exception);

        expect(result.isFailure, isTrue);
        expect(result.message, equals('error message'));
        expect(result.exception, equals(exception));
      });

      test('should execute failure callback in when', () {
        final result = Result<String>.failure('error message');

        final output = result.when(
          success: (data) => 'Success: $data',
          failure: (message, exception) => 'Failure: $message',
        );

        expect(output, equals('Failure: error message'));
      });

      test('should propagate failure in map', () {
        final result = Result<String>.failure('error message');

        final mapped = result.map<int>((data) => data.length);

        expect(mapped.isFailure, isTrue);
        expect(mapped.message, equals('error message'));
      });

      test('should be equal when message and exception are equal', () {
        const result1 = Failure<String>('error');
        const result2 = Failure<String>('error');

        expect(result1, equals(result2));
        expect(result1.hashCode, equals(result2.hashCode));
      });

      test('should have proper toString', () {
        final exception = Exception('test');
        final result = Failure<String>('error message', exception);

        expect(result.toString(), contains('Failure'));
        expect(result.toString(), contains('error message'));
        expect(result.toString(), contains('Exception: test'));
      });
    });

    group('Factory methods', () {
      test('should create success via factory', () {
        final result = Result.success(42);

        expect(result, isA<Success<int>>());
        expect(result.data, equals(42));
      });

      test('should create failure via factory', () {
        final result = Result.failure('error');

        expect(result, isA<Failure>());
        expect(result.message, equals('error'));
      });
    });
  });
}
