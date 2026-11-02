import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/controllers/membership_actions.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/features/care/domain/permissions.dart';
import 'package:i_care/features/settings/presentation/widgets/code_dialog.dart';
import 'package:i_care/features/settings/presentation/widgets/role_choices.dart';
import 'package:i_care/shared/l10n/care_labels.dart';
import 'package:i_care/shared/widgets/app_snack_bars.dart';
import 'package:i_care/shared/widgets/confirm_dialog.dart';
import 'package:i_care/shared/widgets/member_avatar.dart';

/// What an admin can do about [memberId]: their role, a new code, and
/// taking them out of the circle.
Future<void> showMemberSheet(
  BuildContext context, {
  required String memberId,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  showDragHandle: true,
  builder: (_) => MemberSheet(memberId: memberId),
);

class MemberSheet extends ConsumerStatefulWidget {
  const MemberSheet({required this.memberId, super.key});

  final String memberId;

  @override
  ConsumerState<MemberSheet> createState() => _MemberSheetState();
}

class _MemberSheetState extends ConsumerState<MemberSheet> {
  var _busy = false;

  static const _buttonHeight = 48.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final member = ref.watch(membersByIdProvider)[widget.memberId];
    if (member == null || member.isRemoved) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Text(l10n.errorNotFound, style: AppTextStyles.body),
      );
    }
    final lastAdmin = isLastAdmin(ref.watch(membersProvider), member);
    final invited = member.status == MemberStatus.invited;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        0,
        AppSpacing.xl,
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.lg,
        children: [
          Row(
            spacing: AppSpacing.md,
            children: [
              MemberAvatar(member: member, size: _buttonHeight),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(member.name, style: AppTextStyles.headline),
                    Text(
                      [
                        member.role.label(l10n),
                        if (invited) l10n.memberInvitedStatus,
                      ].join(' · '),
                      style: AppTextStyles.bodyMuted.copyWith(
                        color: context.colors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!invited) ...[
            Text(l10n.fieldRole, style: AppTextStyles.label),
            RoleChoices(
              selected: member.role,
              enabled: lastAdmin ? const {MemberRole.admin} : null,
              onChanged: _busy ? null : (role) => _changeRole(member, role),
            ),
          ],
          if (lastAdmin)
            Text(
              l10n.lastAdminNote,
              style: AppTextStyles.bodyMuted.copyWith(
                color: context.colors.inkMuted,
              ),
            ),
          OutlinedButton.icon(
            onPressed: _busy ? null : () => _newCode(member),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(_buttonHeight),
            ),
            icon: const Icon(Icons.key_outlined),
            label: Text(l10n.newCode),
          ),
          Text(
            l10n.newCodeAbout,
            style: AppTextStyles.bodyMuted.copyWith(
              color: context.colors.inkMuted,
            ),
          ),
          if (!lastAdmin)
            TextButton(
              onPressed: _busy
                  ? null
                  : () => invited ? _revoke(member) : _remove(member),
              style: TextButton.styleFrom(
                foregroundColor: context.colors.overdue,
                minimumSize: const Size.fromHeight(_buttonHeight),
              ),
              child: Text(
                invited ? l10n.withdrawInvitation : l10n.removeMember,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _changeRole(Member member, MemberRole role) async {
    if (role == member.role) return;
    await _run(
      () =>
          ref.read(membershipActionsProvider.notifier).changeRole(member, role),
    );
  }

  Future<void> _newCode(Member member) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    final result = await ref
        .read(membershipActionsProvider.notifier)
        .newCode(member);
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case Ok(value: final code):
        await showCodeDialog(context, name: member.name, code: code);
      case Err(:final failure):
        messenger.showError(failure.message(l10n));
    }
  }

  Future<void> _revoke(Member member) async {
    final l10n = context.l10n;
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.withdrawTitle(member.name),
      body: l10n.withdrawBody,
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.withdrawInvitation,
    );
    if (!confirmed || !mounted) return;
    final done = await _run(
      () => ref.read(membershipActionsProvider.notifier).revoke(member),
    );
    if (done && mounted) Navigator.of(context).pop();
  }

  Future<void> _remove(Member member) async {
    final l10n = context.l10n;
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.removeMemberTitle(member.name),
      body: l10n.removeMemberBody,
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.removeMember,
    );
    if (!confirmed || !mounted) return;
    final done = await _run(
      () => ref.read(membershipActionsProvider.notifier).remove(member),
    );
    if (done && mounted) Navigator.of(context).pop();
  }

  /// Runs [action], showing its failure; whether it worked.
  Future<bool> _run(Future<Result<void>> Function() action) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    final result = await action();
    if (mounted) setState(() => _busy = false);
    if (result case Err(:final failure)) {
      messenger.showError(failure.message(l10n));
      return false;
    }
    return true;
  }
}
