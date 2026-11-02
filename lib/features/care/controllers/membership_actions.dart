import 'package:i_care/core/error/result.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/controllers/care_recorder.dart';
import 'package:i_care/features/care/data/care_providers.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/invite_code.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/features/care/domain/repositories/membership_repository.dart';
import 'package:i_care/shared/providers/id_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'membership_actions.g.dart';

/// Who belongs to the circle and which device is whose (`docs/roles.md`).
/// Changes to members are events, carrying the version they were made on;
/// codes, joining and leaving go to the server directly.
@Riverpod(keepAlive: true)
class MembershipActions extends _$MembershipActions {
  @override
  void build() {}

  CareRecorder get _recorder => ref.read(careRecorderProvider);
  MembershipRepository get _membership =>
      ref.read(membershipRepositoryProvider);

  /// Invites [name] as [role] and returns their first code. Callers
  /// check the name is not blank.
  Future<Result<InviteCode>> invite({
    required String name,
    required MemberRole role,
  }) async {
    final memberId = ref.read(newIdProvider)();
    final invited = await _recorder.record(
      CareEvent.memberInvited(
        meta: _recorder.meta(),
        memberId: memberId,
        name: name,
        role: role,
        // Everyone who ever belonged keeps a color, so a new one differs
        // from the latest.
        colorIndex: ref.read(membersByIdProvider).length,
      ),
    );
    if (invited case Err(:final failure)) return Err(failure);
    return _membership.issueCode(memberId);
  }

  /// A code for [member]'s next device, or a fresh one for an invitation
  /// whose code was lost; any unused one stops working.
  Future<Result<InviteCode>> newCode(Member member) =>
      _membership.issueCode(member.id);

  Future<Result<void>> changeRole(Member member, MemberRole role) =>
      _recorder.record(
        CareEvent.roleChanged(
          meta: _recorder.meta(),
          memberId: member.id,
          baseVersion: member.version,
          role: role,
        ),
      );

  Future<Result<void>> remove(Member member) => _recorder.record(
    CareEvent.memberRemoved(
      meta: _recorder.meta(),
      memberId: member.id,
      baseVersion: member.version,
    ),
  );

  /// Withdraws an invitation nobody has used.
  Future<Result<void>> revoke(Member member) => _recorder.record(
    CareEvent.invitationRevoked(meta: _recorder.meta(), memberId: member.id),
  );

  /// Joins this device with [code].
  Future<Result<void>> join(String code) async {
    switch (await _membership.join(code)) {
      case Ok(value: final memberId):
        await ref.read(deviceMembershipProvider.notifier).joined(memberId);
        return const Ok(null);
      case Err(:final failure):
        return Err(failure);
    }
  }

  /// Takes this device out of the circle, sending what is pending first.
  Future<Result<void>> leave() async {
    final memberId = ref.read(deviceMembershipProvider);
    if (memberId == null) return const Ok(null);
    final left = await _membership.leave(memberId);
    if (left case Ok()) {
      await ref.read(deviceMembershipProvider.notifier).cleared();
    }
    return left;
  }

  /// Clears this device once the server said it is not in the circle.
  Future<Result<void>> forget() async {
    final forgotten = await _membership.forget();
    await ref.read(deviceMembershipProvider.notifier).cleared();
    return forgotten;
  }
}
