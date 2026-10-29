import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/core/error/failure.dart';
import 'package:i_care/core/error/guard.dart';
import 'package:i_care/core/error/result.dart';

void main() {
  group('guard', () {
    test('wraps the value in Ok', () async {
      final result = await guard(() async => 42);

      expect(result, isA<Ok<int>>().having((ok) => ok.value, 'value', 42));
    });

    test('maps AppException to its Failure', () async {
      final result = await guard<int>(
        () => throw const ParsingException('bad json'),
      );

      expect(
        result,
        isA<Err<int>>().having(
          (e) => e.failure,
          'failure',
          isA<ParsingFailure>(),
        ),
      );
    });

    test('maps unknown exceptions to UnexpectedFailure', () async {
      final result = await guard<int>(() => throw Exception('boom'));

      expect(
        result,
        isA<Err<int>>().having(
          (e) => e.failure,
          'failure',
          isA<UnexpectedFailure>(),
        ),
      );
    });

    test('lets programming errors through', () {
      expect(guard<int>(() => throw StateError('bug')), throwsStateError);
    });
  });
}
