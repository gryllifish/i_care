import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/settings/controllers/settings_controllers.dart';
import 'package:i_care/features/settings/presentation/widgets/demo_texts.dart';
import 'package:i_care/shared/widgets/app_card.dart';
import 'package:i_care/shared/widgets/confirm_dialog.dart';
import 'package:i_care/shared/widgets/form_section.dart';
import 'package:i_care/shared/widgets/member_list.dart';

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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CircleAvatar(
                      radius: _logoSize / 2,
                      backgroundColor: context.colors.teal,
                      child: Icon(
                        Icons.volunteer_activism,
                        color: context.colors.onAccent,
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
                    l10n.welcomeBody(
                      ref.watch(recipientNameProvider) ?? l10n.theRecipient,
                    ),
                    style: AppTextStyles.body,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppCard(
                    raised: false,
                    color: context.colors.surfaceMuted,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: AppSpacing.sm,
                      children: [
                        if (ref.watch(isSampleCircleProvider))
                          Text(l10n.welcomeSample, style: AppTextStyles.label),
                        Text(
                          l10n.medicalDisclaimer,
                          style: AppTextStyles.bodyMuted.copyWith(
                            color: context.colors.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FormSection(
                    title: l10n.circleTitle,
                    children: const [MemberList()],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
              child: ref.watch(isSampleCircleProvider)
                  ? const _DemoChoice()
                  : FilledButton(
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

/// Only in the demo, while it shows the sample circle: keep exploring it,
/// or clear everything and start as on a first install.
class _DemoChoice extends ConsumerWidget {
  const _DemoChoice();

  static const _buttonHeight = 48.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        Text(
          l10n.welcomeDemoChoice,
          style: AppTextStyles.bodyMuted.copyWith(
            color: context.colors.inkMuted,
          ),
        ),
        FilledButton(
          onPressed: () => ref.read(welcomeSeenProvider.notifier).markSeen(),
          child: Text(l10n.exploreSample),
        ),
        OutlinedButton(
          onPressed: () => _startFromScratch(context, ref),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(_buttonHeight),
          ),
          child: Text(l10n.startFromScratch),
        ),
      ],
    );
  }

  Future<void> _startFromScratch(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final startEmpty = ref.read(demoStartEmptyProvider);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.startEmptyTitle,
      body: startEmptyBody(l10n, ref.read(demoLayoutProvider)),
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.startFromScratch,
    );
    if (!confirmed) return;
    // The phones then offer to create a circle or join one.
    await startEmpty();
  }
}
