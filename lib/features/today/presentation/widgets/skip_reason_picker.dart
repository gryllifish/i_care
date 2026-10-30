import 'package:flutter/material.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/shared/l10n/care_labels.dart';

/// Why a dose was not given or a task not done: one button per reason.
/// Disabled while [onPicked] is null.
class SkipReasonPicker extends StatelessWidget {
  const SkipReasonPicker({
    required this.title,
    required this.reasons,
    required this.onPicked,
    super.key,
  });

  final String title;
  final List<SkipReason> reasons;
  final ValueChanged<SkipReason>? onPicked;

  static const _buttonHeight = 48.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final onPicked = this.onPicked;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        Text(title, style: AppTextStyles.label),
        for (final reason in reasons)
          OutlinedButton(
            onPressed: onPicked == null ? null : () => onPicked(reason),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(_buttonHeight),
            ),
            child: Text(reason.label(l10n)),
          ),
      ],
    );
  }
}
