import 'package:freezed_annotation/freezed_annotation.dart';

part 'invite_code.freezed.dart';

/// A one-time code that lets one device join the circle as one member
/// (`docs/roles.md`).
@freezed
abstract class InviteCode with _$InviteCode {
  const factory InviteCode({
    /// As shown to people, e.g. "K7P-4QM".
    required String code,

    /// By the server's clock; the phone only shows it.
    required DateTime expiresAt,
  }) = _InviteCode;
}
