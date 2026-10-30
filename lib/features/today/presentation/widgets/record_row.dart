import 'package:flutter/material.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/features/care/domain/entities/caregiver.dart';
import 'package:i_care/shared/widgets/caregiver_avatar.dart';

/// Who recorded something and when, with a button to take it back when
/// [onRemove] is set.
class RecordRow extends StatelessWidget {
  const RecordRow({
    required this.caregiver,
    required this.name,
    required this.text,
    required this.onRemove,
    super.key,
  });

  final Caregiver? caregiver;
  final String name;
  final String text;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final caregiver = this.caregiver;
    final onRemove = this.onRemove;
    return Row(
      spacing: AppSpacing.md,
      children: [
        if (caregiver != null) CaregiverAvatar(caregiver: caregiver),
        Expanded(child: Text(text, style: AppTextStyles.body)),
        if (onRemove != null)
          TextButton(
            onPressed: onRemove,
            child: Text(
              context.l10n.remove,
              semanticsLabel: context.l10n.removeRecordOf(name),
            ),
          ),
      ],
    );
  }
}
