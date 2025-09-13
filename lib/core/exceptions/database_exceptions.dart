abstract class DatabaseException implements Exception {
  const DatabaseException(this.message, [this.cause]);

  final String message;
  final dynamic cause;

  @override
  String toString() =>
      'DatabaseException: $message${cause != null ? ' (cause: $cause)' : ''}';
}

class DatabaseInitException extends DatabaseException {
  const DatabaseInitException(super.message, [super.cause]);

  @override
  String toString() =>
      'DatabaseInitException: $message${cause != null ? ' (cause: $cause)' : ''}';
}

class DatabaseOperationException extends DatabaseException {
  const DatabaseOperationException(super.message, [super.cause]);

  @override
  String toString() =>
      'DatabaseOperationException: $message${cause != null ? ' (cause: $cause)' : ''}';
}

class RecordNotFoundException extends DatabaseException {
  const RecordNotFoundException(super.message, [super.cause]);

  @override
  String toString() =>
      'RecordNotFoundException: $message${cause != null ? ' (cause: $cause)' : ''}';
}

class ValidationException extends DatabaseException {
  const ValidationException(super.message, [super.cause]);

  @override
  String toString() =>
      'ValidationException: $message${cause != null ? ' (cause: $cause)' : ''}';
}
