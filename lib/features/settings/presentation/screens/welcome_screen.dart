import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/features/care/data/sample/sample_circle.dart';
import 'package:i_care/features/settings/controllers/settings_controllers.dart';
import 'package:i_care/shared/widgets/app_card.dart';
import 'package:i_care/shared/widgets/caregiver_choices.dart';
import 'package:i_care/shared/widgets/form_section.dart';

/// First run on a phone: what ICare is, that it gives no medical advice,
/// and who uses this phone.
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  static const _logoSize = 72.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenHorizontal,
                  AppSpacing.xxl,
                  AppSpacing.screenHorizontal,
                  AppSpacing.lg,
                ),
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: CircleAvatar(
                      radius: _logoSize / 2,
                      backgroundColor: AppColors.teal,
                      child: Icon(
                        Icons.volunteer_activism,
                        color: AppColors.onAccent,
                        size: _logoSize / 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Semantics(
                    container: true,
                    header: true,
                    child: Text(
                      l10n.welcomeTitle,
                      style: AppTextStyles.display,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.welcomeBody(SampleCircle.recipientName),
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppCard(
                    raised: false,
                    color: AppColors.surfaceMuted,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: AppSpacing.sm,
                      children: [
                        Text(l10n.welcomeSample, style: AppTextStyles.label),
                        Text(
                          l10n.medicalDisclaimer,
                          style: AppTextStyles.bodyMuted,
                        ),
                      ],
                    ),
                  ),
                  FormSection(
                    title: l10n.welcomeWho,
                    children: const [CaregiverChoices()],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
              child: FilledButton(
                onPressed: () =>
                    ref.read(welcomeSeenProvider.notifier).markSeen(),
                child: Text(l10n.welcomeStart),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
