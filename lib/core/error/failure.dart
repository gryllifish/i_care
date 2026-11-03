/// Typed error categories that repositories return instead of raw exceptions.
///
/// Implements [Exception] so a controller can throw it into an `AsyncValue`
/// and the UI can pattern match on it. Add a subclass per category the UI
/// needs to tell apart.
sealed class Failure implements Exception {
  const Failure({this.cause});

  /// The underlying error, kept for logging only. Never shown to users.
  final Object? cause;

  /// Whether trying again later may succeed, e.g. once the network is back.
  bool get isTransient => false;
}

/// The device could not reach the server (offline, DNS, refused).
final class NoConnectionFailure extends Failure {
  const NoConnectionFailure({super.cause});

  @override
  bool get isTransient => true;
}

/// The server took too long to answer.
final class TimeoutFailure extends Failure {
  const TimeoutFailure({super.cause});

  @override
  bool get isTransient => true;
}

/// The server answered with an error status.
final class ServerFailure extends Failure {
  const ServerFailure({this.statusCode, super.cause});

  final int? statusCode;

  /// 5xx errors are usually temporary, and so are "too many requests"
  /// (429) and "request timeout" (408). Other 4xx mean the request itself
  /// is wrong.
  @override
  bool get isTransient => switch (statusCode ?? 500) {
    408 || 429 => true,
    final code => code >= 500,
  };
}

/// Local storage or bundled assets could not be read.
final class StorageFailure extends Failure {
  const StorageFailure({super.cause});
}

/// Data was read but did not match the expected format.
final class ParsingFailure extends Failure {
  const ParsingFailure({super.cause});
}

/// The requested item does not exist.
final class NotFoundFailure extends Failure {
  const NotFoundFailure({super.cause});
}

/// Anything the data layer did not anticipate.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.cause});
}

/// This device does not belong to the circle, or no longer does.
final class NotMemberFailure extends Failure {
  const NotMemberFailure({super.cause});
}

/// The member's role does not allow what was asked.
final class ForbiddenFailure extends Failure {
  const ForbiddenFailure({super.cause});
}

/// Why an invitation code cannot be used.
enum CodeProblem {
  unknown,
  used,
  expired,

  /// Too many wrong codes from this device: it has to wait.
  locked,
}

/// An invitation code that cannot be used.
final class InvalidCodeFailure extends Failure {
  const InvalidCodeFailure(this.problem, {super.cause});

  final CodeProblem problem;
}
