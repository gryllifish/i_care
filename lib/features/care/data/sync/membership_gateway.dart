import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/features/care/domain/entities/invite_code.dart';

/// Joining a circle and inviting to it: requests to the server, outside
/// the event log. The simulated server answers them now; Postgres
/// functions on Supabase will in stage 2 (`docs/roles.md`).
abstract interface class MembershipGateway {
  /// A new code for [memberId], replacing any unused one. Admins only.
  ///
  /// Throws [NoConnectionException], [NotMemberException],
  /// [ForbiddenException] or [NotFoundException].
  Future<InviteCode> issueCode(String memberId);

  /// Creates a circle for [recipientName], with this device joined as
  /// its first admin, [creatorName]; returns their member id.
  ///
  /// Throws [NoConnectionException] or [ForbiddenException] (a circle
  /// already exists).
  Future<String> createCircle({
    required String creatorName,
    required String recipientName,
  });

  /// Joins this device as the member [code] was issued for; returns
  /// their id.
  ///
  /// Throws [NoConnectionException] or [InvalidCodeException].
  Future<String> join(String code);

  /// Deletes this device's circle with everything in it, for everyone:
  /// what the person cared for may ask for (`docs/privacy.md`). Admins
  /// only.
  ///
  /// Throws [NoConnectionException], [NotMemberException] or
  /// [ForbiddenException].
  Future<void> deleteCircle();

  /// Ends this device's own session with the server, once it left, was
  /// removed or deleted its circle: whoever uses it next starts as a new
  /// device, with nothing of the account before (`docs/roles.md`,
  /// recoverable access). Never fails: the session is gone here even
  /// when the server cannot be told.
  Future<void> forgetDevice();
}
