import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/features/settings/controllers/settings_controllers.dart';
import 'package:i_care/shared/widgets/app_card.dart';
import 'package:i_care/shared/widgets/caregiver_choices.dart';
import 'package:i_care/shared/widgets/confirm_dialog.dart';
import 'package:i_care/shared/widgets/form_section.dart';
import 'package:i_care/shared/widgets/segmented_control.dart';

/// Who uses this phone, its language, the demo's reset and the medical
/// disclaimer.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final language = ref.watch(appLanguageProvider)?.languageCode;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenHorizontal,
          0,
          AppSpacing.screenHorizontal,
          AppSpacing.xxl,
        ),
        children: [
          FormSection(
            title: l10n.sectionWho,
            children: const [CaregiverChoices()],
          ),
          FormSection(
            title: l10n.sectionLanguage,
            children: [
              SegmentedControl<String>(
                options: {
                  _system: l10n.languageSystem,
                  // Each language named in itself, as everywhere.
                  'es': 'Español',
                  'en': 'English',
                },
                selected: language ?? _system,
                onChanged: (code) => ref
                    .read(appLanguageProvider.notifier)
                    .choose(code == _system ? null : Locale(code)),
              ),
            ],
          ),
          FormSection(
            title: l10n.sectionDemo,
            children: [
              Text(l10n.resetDemoBody, style: AppTextStyles.bodyMuted),
              OutlinedButton.icon(
                onPressed: () => _reset(context, ref),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.overdue,
                ),
                icon: const Icon(Icons.restart_alt),
                label: Text(l10n.resetDemo),
              ),
            ],
          ),
          FormSection(
            title: l10n.sectionAbout,
            children: [
              AppCard(
                raised: false,
                color: AppColors.surfaceMuted,
                child: Text(
                  l10n.medicalDisclaimer,
                  style: AppTextStyles.bodyMuted,
                ),
              ),
              TextButton(
                onPressed: () => showLicensePage(
                  context: context,
                  applicationName: l10n.appTitle,
                ),
                child: Text(l10n.licenses),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static const _system = 'system';

  Future<void> _reset(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final reset = ref.read(demoResetProvider);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.resetDemo,
      body: l10n.resetDemoBody,
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.resetDemoConfirm,
    );
    if (!confirmed) return;
    await reset();
    messenger.showSnackBar(SnackBar(content: Text(l10n.resetDone)));
  }
}
