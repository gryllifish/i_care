import 'package:i_care/core/error/result.dart';

/// What the system says about notifications on this phone.
enum PushPermission {
  /// Allowed: the phone is told about the circle's news.
  allowed,

  /// Refused, now or in the system's settings; changed only there.
  denied,

  /// Never asked yet.
  notAsked,
}

/// Push notifications on this phone about the circle's news
/// (`docs/backend.md`, "Push notifications"). Whether they arrive is the
/// system's permission alone: once allowed, the phone keeps its token on
/// the server by itself. `language` is the one messages are written in:
/// `en` or `es`.
abstract interface class PushRepository {
  /// The system's answer so far, without asking.
  Future<Result<PushPermission>> permission();

  /// Asks the system, which shows its dialog only the first time, then
  /// keeps this phone's token on the server when allowed.
  Future<Result<PushPermission>> request({required String language});

  /// Keeps this phone's token on the server when allowed, and has the
  /// server forget it when refused: on every start and language change,
  /// since the token or the permission may have changed. Needs a
  /// connection.
  Future<Result<PushPermission>> sync({required String language});
}
