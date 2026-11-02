import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/shared/l10n/care_labels.dart';
import 'package:i_care/shared/widgets/app_card.dart';
import 'package:i_care/shared/widgets/member_avatar.dart';
import 'package:i_care/shared/widgets/status_pill.dart';

/// The circle's members with their roles, this phone's member marked.
/// A phone belongs to whoever joined on it; [onSelected], when set (for
/// admins), opens what can be done about a member.
class MemberList extends ConsumerWidget {
  const MemberList({this.onSelected, super.key});

  final ValueChanged<Member>? onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final ownerId = ref.watch(deviceMembershipProvider);
    final onSelected = this.onSelected;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        for (final member in ref.watch(membersProvider))
          MergeSemantics(
            child: AppCard(
              raised: false,
              color: member.id == ownerId
                  ? context.colors.tealSoft
                  : context.colors.surface,
              onTap: onSelected == null ? null : () => onSelected(member),
              child: Row(
                spacing: AppSpacing.md,
                children: [
                  MemberAvatar(member: member),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: AppSpacing.xxs,
                      children: [
                        Text(member.name, style: AppTextStyles.label),
                        Text(
                          [
                            member.role.label(l10n),
                            if (member.status == MemberStatus.invited)
                              l10n.memberInvitedStatus,
                          ].join(' · '),
                          style: AppTextStyles.bodyMuted.copyWith(
                            color: context.colors.inkMuted,
                          ),
                        ),
                        if (member.id == ownerId)
                          Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.xs),
                            child: StatusPill(
                              icon: Icons.smartphone,
                              label: l10n.thisPhone,
                              color: context.colors.tealDark,
                              background: context.colors.surface,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
