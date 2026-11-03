import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/router/app_routes.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/domain/permissions.dart';
import 'package:i_care/features/settings/controllers/settings_controllers.dart';
import 'package:i_care/features/settings/presentation/widgets/circle_section.dart';
import 'package:i_care/features/settings/presentation/widgets/not_sent_section.dart';
import 'package:i_care/shared/widgets/app_card.dart';
import 'package:i_care/shared/widgets/app_snack_bars.dart';
import 'package:i_care/shared/widgets/confirm_dialog.dart';
import 'package:i_care/shared/widgets/form_section.dart';
import 'package:i_care/shared/widgets/segmented_control.dart';

/// The circle and this phone's place in it, language, theme, the demo's
/// reset and the medical disclaimer.
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
          const NotSentSection(),
          const CircleSection(),
          if (ref.watch(canDoProvider(CareAction.manageReasons)))
            FormSection(
              title: l10n.sectionReasons,
              children: [
                AppCard(
                  onTap: () => context.push(AppRoutes.reasons),
                  child: Row(
                    spacing: AppSpacing.md,
                    children: [
                      Expanded(
                        child: Text(
                          l10n.editReasons,
                          style: AppTextStyles.body,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: context.colors.inkMuted,
                      ),
                    ],
                  ),
                ),
              ],
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
            title: l10n.sectionAppearance,
            children: [
              SegmentedControl<ThemeMode>(
                options: {
                  ThemeMode.system: l10n.themeSystem,
                  ThemeMode.light: l10n.themeLight,
                  ThemeMode.dark: l10n.themeDark,
                },
                selected: ref.watch(appThemeModeProvider),
                onChanged: ref.read(appThemeModeProvider.notifier).choose,
              ),
            ],
          ),
          if (ref.watch(canDoProvider(CareAction.resetDemo)))
            FormSection(
              title: l10n.sectionDemo,
              children: [
                Text(
                  l10n.resetDemoBody,
                  style: AppTextStyles.bodyMuted.copyWith(
                    color: context.colors.inkMuted,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => _reset(context, ref),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.colors.overdue,
                  ),
                  icon: const Icon(Icons.restart_alt),
                  label: Text(l10n.resetDemo),
                ),
                OutlinedButton.icon(
                  onPressed: () => _startEmpty(context, ref),
                  icon: const Icon(Icons.layers_clear_outlined),
                  label: Text(l10n.startFromScratch),
                ),
              ],
            ),
          FormSection(
            title: l10n.sectionAbout,
            children: [
              AppCard(
                raised: false,
                color: context.colors.surfaceMuted,
                child: Text(
                  l10n.medicalDisclaimer,
                  style: AppTextStyles.bodyMuted.copyWith(
                    color: context.colors.inkMuted,
                  ),
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
    messenger.showMessage(l10n.resetDone);
  }

  Future<void> _startEmpty(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final startEmpty = ref.read(demoStartEmptyProvider);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.startEmptyTitle,
      body: l10n.startEmptyBody,
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.startFromScratch,
    );
    if (!confirmed) return;
    // The phones then offer to create a circle or join one.
    await startEmpty();
  }
}
