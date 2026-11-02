import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/error/failure.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/controllers/membership_actions.dart';
import 'package:i_care/features/care/domain/permissions.dart';
import 'package:i_care/features/settings/presentation/widgets/invite_sheet.dart';
import 'package:i_care/features/settings/presentation/widgets/member_sheet.dart';
import 'package:i_care/shared/widgets/app_snack_bars.dart';
import 'package:i_care/shared/widgets/confirm_dialog.dart';
import 'package:i_care/shared/widgets/form_section.dart';
import 'package:i_care/shared/widgets/member_list.dart';

/// The circle's members; admins open each one and invite more. Anyone
/// can take this phone out of the circle.
class CircleSection extends ConsumerWidget {
  const CircleSection({super.key});

  static const _buttonHeight = 48.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final me = ref.watch(currentMemberProvider);
    final manages = me != null && can(me.role, CareAction.manageMembers);
    return FormSection(
      title: l10n.circleTitle,
      children: [
        MemberList(
          onSelected: manages
              ? (member) => showMemberSheet(context, memberId: member.id)
              : null,
        ),
        if (manages)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => showInviteSheet(context),
              icon: const Icon(Icons.person_add_alt),
              label: Text(l10n.inviteSomeone),
            ),
          ),
        if (me != null)
          TextButton(
            onPressed: () => _leave(context, ref),
            style: TextButton.styleFrom(
              foregroundColor: context.colors.overdue,
              minimumSize: const Size.fromHeight(_buttonHeight),
            ),
            child: Text(l10n.leaveCircle),
          ),
      ],
    );
  }

  Future<void> _leave(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.leaveTitle,
      body: l10n.leaveBody,
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.leave,
    );
    if (!confirmed) return;
    // On success the router moves on to joining.
    final result = await ref.read(membershipActionsProvider.notifier).leave();
    if (result case Err(:final failure)) {
      messenger.showError(
        failure is NoConnectionFailure
            ? l10n.leaveOffline
            : failure.message(l10n),
      );
    }
  }
}
