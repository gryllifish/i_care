import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/core/error/failure.dart';
import 'package:i_care/core/error/retry_policy.dart';

void main() {
  test('never retries deterministic failures', () {
    expect(retryPolicy(0, const ParsingFailure()), isNull);
    expect(retryPolicy(0, const ServerFailure(statusCode: 404)), isNull);
  });

  test('retries transient failures', () {
    expect(retryPolicy(0, const NoConnectionFailure()), isNotNull);
    expect(retryPolicy(0, const TimeoutFailure()), isNotNull);
    expect(retryPolicy(0, const ServerFailure(statusCode: 503)), isNotNull);
  });

  test('retries rate limits and request timeouts', () {
    expect(retryPolicy(0, const ServerFailure(statusCode: 429)), isNotNull);
    expect(retryPolicy(0, const ServerFailure(statusCode: 408)), isNotNull);
  });

  test('never retries programming errors', () {
    expect(retryPolicy(0, StateError('bug')), isNull);
  });

  test('backs off exponentially, then gives up', () {
    final error = Exception('flaky');

    expect(retryPolicy(0, error), const Duration(milliseconds: 200));
    expect(retryPolicy(1, error), const Duration(milliseconds: 400));
    expect(retryPolicy(2, error), const Duration(milliseconds: 800));
    expect(retryPolicy(3, error), isNull);
  });
}
