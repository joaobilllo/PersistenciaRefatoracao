abstract class Result<T> {
  const Result();

  factory Result.success(T data) = Success<T>;
  factory Result.failure(String message, [Exception? exception]) = Failure<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get data => isSuccess ? (this as Success<T>).data : null;
  String? get message => isFailure ? (this as Failure<T>).message : null;
  Exception? get exception => isFailure ? (this as Failure<T>).exception : null;

  Result<R> map<R>(R Function(T data) transform) {
    if (isSuccess) {
      try {
        return Result.success(transform((this as Success<T>).data));
      } catch (e) {
        return Result.failure(
          'Transformation failed: $e',
          e is Exception ? e : Exception(e.toString()),
        );
      }
    }
    return Result.failure(
      (this as Failure<T>).message,
      (this as Failure<T>).exception,
    );
  }

  R when<R>({
    required R Function(T data) success,
    required R Function(String message, Exception? exception) failure,
  }) {
    if (isSuccess) {
      return success((this as Success<T>).data);
    }
    final failureResult = this as Failure<T>;
    return failure(failureResult.message, failureResult.exception);
  }
}

class Success<T> extends Result<T> {
  const Success(this.data);

  @override
  final T data;

  @override
  String toString() => 'Success(data: $data)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Success<T> && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;
}

class Failure<T> extends Result<T> {
  const Failure(this.message, [this.exception]);

  @override
  final String message;
  @override
  final Exception? exception;

  @override
  String toString() => 'Failure(message: $message, exception: $exception)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure<T> &&
        other.message == message &&
        other.exception == exception;
  }

  @override
  int get hashCode => Object.hash(message, exception);
}
