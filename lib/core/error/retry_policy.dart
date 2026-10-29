import 'package:i_care/core/error/failure.dart';

/// Decides whether a failed provider is retried, for `ProviderScope.retry`.
///
/// Returns the delay before the next attempt, or null to stop. Transient
/// [Failure]s (offline, timeout, 5xx) and unknown exceptions get a few
/// attempts with exponential backoff. Other failures are deterministic (bad
/// data, missing item), so retrying only repeats the error; programming
/// [Error]s are never retried either.
Duration? retryPolicy(int retryCount, Object error) {
  const maxRetries = 3;
  const baseDelay = Duration(milliseconds: 200);

  final deterministic = error is Failure && !error.isTransient;
  if (deterministic || error is Error || retryCount >= maxRetries) {
    return null;
  }
  return baseDelay * (1 << retryCount);
}
