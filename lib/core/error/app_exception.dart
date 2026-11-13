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
    NotMemberException() => NotMemberFailure(cause: this),
    ForbiddenException() => ForbiddenFailure(cause: this),
    InvalidCodeException(:final problem) => InvalidCodeFailure(
      problem,
      cause: this,
    ),
    AccountInUseException() => AccountInUseFailure(cause: this),
    NoAccessException() => NoAccessFailure(cause: this),
    GoogleSignInFailedException() => GoogleSignInFailure(cause: this),
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

/// This device does not belong to the circle, or no longer does.
final class NotMemberException extends AppException {
  const NotMemberException(super.message, {super.cause});
}

/// The member's role does not allow what was asked.
final class ForbiddenException extends AppException {
  const ForbiddenException(super.message, {super.cause});
}

/// An invitation code that cannot be used.
final class InvalidCodeException extends AppException {
  const InvalidCodeException(this.problem, super.message, {super.cause});

  final CodeProblem problem;
}

/// The Google account already protects another access: someone else's,
/// or this person's on another phone.
final class AccountInUseException extends AppException {
  const AccountInUseException(super.message, {super.cause});
}

/// No access is protected with that Google account.
final class NoAccessException extends AppException {
  const NoAccessException(super.message, {super.cause});
}

/// Google's account sheet could not hand over an account: none on the
/// phone, the build is not set up for it, or Google is unreachable.
final class GoogleSignInFailedException extends AppException {
  const GoogleSignInFailedException(super.message, {super.cause});
}
