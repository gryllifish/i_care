import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/features/care/domain/entities/invite_code.dart';

/// Joining a circle and inviting to it: requests to the server, outside
/// the event log. The simulated server answers them now; callable Cloud
/// Functions will in stage 2 (`docs/roles.md`).
abstract interface class MembershipGateway {
  /// A new code for [memberId], replacing any unused one. Admins only.
  ///
  /// Throws [NoConnectionException], [NotMemberException],
  /// [ForbiddenException] or [NotFoundException].
  Future<InviteCode> issueCode(String memberId);

  /// Joins this device as the member [code] was issued for; returns
  /// their id.
  ///
  /// Throws [NoConnectionException] or [InvalidCodeException].
  Future<String> join(String code);
}
