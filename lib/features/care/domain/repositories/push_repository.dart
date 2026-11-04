import 'package:i_care/core/error/result.dart';

/// Push notifications on this phone about the circle's news
/// (`docs/backend.md`, "Push notifications"). `language` is the one
/// messages are written in: `en` or `es`.
abstract interface class PushRepository {
  /// Asks for permission when needed, then has this phone told.
  Future<Result<void>> enable({required String language});

  /// Sends this phone's token again, since it may have changed; does
  /// nothing when notifications are not allowed. Needs a connection.
  Future<Result<void>> refresh({required String language});

  /// Stops telling this phone.
  Future<Result<void>> disable();
}
