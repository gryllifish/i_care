import 'package:i_care/core/error/failure.dart';

/// Outcome of an operation that can fail in an expected way.
///
/// Repositories return `Result` so callers must handle both branches
/// explicitly with pattern matching:
///
/// ```dart
/// switch (await repository.getClients()) {
///   case Ok(:final value): ...
///   case Err(:final failure): ...
/// }
/// ```
sealed class Result<T> {
  const Result();

  /// Returns the value or throws the [Failure].
  ///
  /// Meant for `AsyncNotifier.build`, where a thrown [Failure] becomes an
  /// `AsyncError` the UI can render.
  T getOrThrow() => switch (this) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);

  final T value;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);

  final Failure failure;
}
