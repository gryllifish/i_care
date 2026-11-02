import 'package:i_care/core/error/result.dart';
import 'package:i_care/features/care/domain/entities/invite_code.dart';

/// Who this device belongs to, and how it joins or leaves a circle
/// (`docs/roles.md`). Changes to members themselves (invite, role,
/// remove) are events, recorded through the care log.
abstract interface class MembershipRepository {
  /// A one-time code for [memberId]'s next device. Sends anything pending
  /// first, so an invitation just recorded has reached the server. Needs a
  /// connection.
  Future<Result<InviteCode>> issueCode(String memberId);

  /// Joins this device with [code]; returns the member's id. Starts this
  /// device's copy of the log over.
  Future<Result<String>> join(String code);

  /// Takes this device out of the circle as [memberId]: sends what is
  /// still pending (failing if it cannot), records that it left, and
  /// clears its copy of the log.
  Future<Result<void>> leave(String memberId);

  /// Clears this device's copy of the log once the server said it is no
  /// longer in the circle (and anything pending was sent).
  Future<Result<void>> forget();
}
