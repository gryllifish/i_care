import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/domain/entities/caregiver.dart';
import 'package:i_care/shared/widgets/app_card.dart';
import 'package:i_care/shared/widgets/caregiver_avatar.dart';

/// The circle's members as cards; picking one makes them the person
/// recording on this phone.
class CaregiverChoices extends ConsumerWidget {
  const CaregiverChoices({this.onChosen, super.key});

  /// Called after a choice, e.g. to close the sheet it is in.
  final VoidCallback? onChosen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(currentCaregiverProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        for (final caregiver in ref.watch(caregiversProvider))
          Semantics(
            selected: caregiver == current,
            child: AppCard(
              raised: false,
              color: caregiver == current
                  ? AppColors.tealSoft
                  : AppColors.surface,
              onTap: () => _choose(ref, caregiver),
              child: Row(
                spacing: AppSpacing.md,
                children: [
                  CaregiverAvatar(caregiver: caregiver),
                  Expanded(
                    child: Text(caregiver.name, style: AppTextStyles.label),
                  ),
                  if (caregiver == current)
                    const Icon(Icons.check_circle, color: AppColors.teal),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _choose(WidgetRef ref, Caregiver caregiver) async {
    // Read before reporting: the caller may close the sheet this is in.
    final current = ref.read(currentCaregiverProvider.notifier);
    onChosen?.call();
    await current.select(caregiver);
  }
}
