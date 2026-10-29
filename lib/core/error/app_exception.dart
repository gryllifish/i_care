import 'package:i_care/core/error/failure.dart';

/// Exceptions thrown by data sources.
///
/// They never leave the data layer: repositories convert them into a
/// [Failure] through `guard`.
sealed class AppException implements Exception {
  const AppException(this.message, {this.cause});

  final String message;
  final Object? cause;

  Failure toFailure() => switch (this) {
    StorageException() => StorageFailure(cause: this),
    ParsingException() => ParsingFailure(cause: this),
    NotFoundException() => NotFoundFailure(cause: this),
    NoConnectionException() => NoConnectionFailure(cause: this),
    RequestTimeoutException() => TimeoutFailure(cause: this),
    ServerException(:final statusCode) => ServerFailure(
      statusCode: statusCode,
      cause: this,
    ),
  };

  @override
  String toString() => 'AppException: $message (cause: $cause)';
}

final class StorageException extends AppException {
  const StorageException(super.message, {super.cause});
}

final class ParsingException extends AppException {
  const ParsingException(super.message, {super.cause});
}

final class NotFoundException extends AppException {
  const NotFoundException(super.message, {super.cause});
}

final class NoConnectionException extends AppException {
  const NoConnectionException(super.message, {super.cause});
}

/// Named to avoid clashing with `dart:async`'s `TimeoutException`.
final class RequestTimeoutException extends AppException {
  const RequestTimeoutException(super.message, {super.cause});
}

final class ServerException extends AppException {
  const ServerException(super.message, {this.statusCode, super.cause});

  final int? statusCode;
}
