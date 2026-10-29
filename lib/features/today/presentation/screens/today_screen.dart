import 'package:flutter/material.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';

/// Today's doses. Placeholder until phase 1 builds the dose timeline.
class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
            vertical: AppSpacing.xl,
          ),
          children: [
            Text(l10n.todayTitle, style: AppTextStyles.headline),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.medicalDisclaimer, style: AppTextStyles.bodyMuted),
          ],
        ),
      ),
    );
  }
}
