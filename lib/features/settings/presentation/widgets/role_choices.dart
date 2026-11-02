import 'package:flutter/material.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/shared/l10n/care_labels.dart';
import 'package:i_care/shared/widgets/app_card.dart';

/// Every role with what it may do; the [selected] one marked. Roles left
/// out of [enabled] show but cannot be chosen.
class RoleChoices extends StatelessWidget {
  const RoleChoices({
    required this.selected,
    required this.onChanged,
    this.enabled,
    super.key,
  });

  final MemberRole selected;
  final ValueChanged<MemberRole>? onChanged;

  /// Null means every role.
  final Set<MemberRole>? enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final onChanged = this.onChanged;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        for (final role in MemberRole.values)
          Semantics(
            selected: role == selected,
            child: AppCard(
              raised: false,
              color: role == selected
                  ? context.colors.tealSoft
                  : context.colors.surface,
              onTap: onChanged == null || !(enabled?.contains(role) ?? true)
                  ? null
                  : () => onChanged(role),
              child: Row(
                spacing: AppSpacing.md,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: AppSpacing.xxs,
                      children: [
                        Text(role.label(l10n), style: AppTextStyles.label),
                        Text(
                          role.about(l10n),
                          style: AppTextStyles.bodyMuted.copyWith(
                            color: context.colors.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (role == selected)
                    Icon(Icons.check_circle, color: context.colors.teal),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
