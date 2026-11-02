import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/router/app_routes.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/core/utils/formatters.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/domain/entities/recipient_profile.dart';
import 'package:i_care/features/care/domain/permissions.dart';
import 'package:i_care/features/emergency/controllers/emergency_card.dart';
import 'package:i_care/features/emergency/presentation/widgets/emergency_text.dart';
import 'package:i_care/shared/l10n/schedule_text.dart';
import 'package:i_care/shared/providers/now_provider.dart';
import 'package:i_care/shared/providers/phone_provider.dart';
import 'package:i_care/shared/widgets/app_card.dart';
import 'package:i_care/shared/widgets/app_snack_bars.dart';
import 'package:i_care/shared/widgets/edit_conflict_card.dart';
import 'package:i_care/shared/widgets/error_view.dart';
import 'package:i_care/shared/widgets/form_section.dart';
import 'package:i_care/shared/widgets/medication_icon.dart';

/// What a doctor or an ambulance needs to know, large and in one place:
/// allergies first, then conditions, medications and who to call.
class EmergencyCardScreen extends ConsumerWidget {
  const EmergencyCardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final card = ref.watch(emergencyCardProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.emergencyCard),
        actions: [
          if (ref.watch(canDoProvider(CareAction.editEmergencyCard)))
            IconButton(
              tooltip: l10n.editProfile,
              onPressed: () => context.push(AppRoutes.editEmergencyPath()),
              icon: const Icon(Icons.edit_outlined),
            ),
        ],
      ),
      body: switch (card) {
        AsyncData(:final value) => _CardContent(card: value),
        AsyncError(:final error) => ErrorView(
          message: l10n.errorMessage(error),
          onRetry: () => ref.invalidate(careLogProvider),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _CardContent extends ConsumerWidget {
  const _CardContent({required this.card});

  final EmergencyCard card;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final today = ref.watch(nowProvider);
    final profile = card.profile;
    if (profile == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.lg,
            children: [
              Text(
                l10n.emptyProfile,
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
              FilledButton(
                onPressed: () => context.push(AppRoutes.editEmergencyPath()),
                child: Text(l10n.fillIn),
              ),
            ],
          ),
        ),
      );
    }
    final age = profile.ageOn(today);
    final allergies = linesOf(profile.allergies);
    final conditions = linesOf(profile.conditions);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        0,
        AppSpacing.screenHorizontal,
        AppSpacing.xxl,
      ),
      children: [
        Text(profile.name, style: AppTextStyles.display),
        if (age != null)
          Text(
            [
              l10n.ageYears(age),
              if (profile.birthDate case final DateTime birth)
                Formatters.fullDate(birth, locale),
            ].join(' · '),
            style: AppTextStyles.body,
          ),
        for (final conflict in card.conflicts) ...[
          const SizedBox(height: AppSpacing.lg),
          EditConflictCard(
            conflict: conflict,
            summarize: profileChangeSummary,
            onChoose: (change) => ref
                .read(profileActionsProvider.notifier)
                .resolve(
                  conflict,
                  chosen: change,
                  currentVersion: card.profileVersion,
                ),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        _Allergies(allergies: allergies),
        if (conditions.isNotEmpty)
          FormSection(
            title: l10n.conditionsTitle,
            children: [
              AppCard(
                child: Text(
                  conditions.join('\n'),
                  style: AppTextStyles.title,
                ),
              ),
            ],
          ),
        if (card.medications.isNotEmpty)
          FormSection(
            title: l10n.medicationsTitle,
            children: [
              AppCard(
                child: Column(
                  spacing: AppSpacing.md,
                  children: [
                    for (final medication in card.medications)
                      MergeSemantics(
                        child: Row(
                          spacing: AppSpacing.md,
                          children: [
                            MedicationIcon(form: medication.details.form),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${medication.details.name} '
                                    '${medication.details.strength}',
                                    style: AppTextStyles.label,
                                  ),
                                  Text(
                                    medication.schedule.describe(l10n, locale),
                                    style: AppTextStyles.bodyMuted.copyWith(
                                      color: context.colors.inkMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        if (profile.doctors.isNotEmpty)
          FormSection(
            title: l10n.doctorsTitle,
            children: [
              for (final doctor in profile.doctors) _ContactCard(doctor),
            ],
          ),
        if (profile.contacts.isNotEmpty)
          FormSection(
            title: l10n.contactsTitle,
            children: [
              for (final contact in profile.contacts) _ContactCard(contact),
            ],
          ),
        if (profile.notes.trim().isNotEmpty)
          FormSection(
            title: l10n.notesTitle,
            children: [
              AppCard(
                child: Text(profile.notes.trim(), style: AppTextStyles.body),
              ),
            ],
          ),
        const SizedBox(height: AppSpacing.xl),
        FilledButton.icon(
          onPressed: () => _copy(context, ref),
          icon: const Icon(Icons.copy),
          label: Text(l10n.copyAsText),
        ),
      ],
    );
  }

  Future<void> _copy(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(
      ClipboardData(
        text: emergencyText(
          card,
          l10n,
          locale: Localizations.localeOf(context).toLanguageTag(),
          today: ref.read(nowProvider),
        ),
      ),
    );
    messenger.showMessage(l10n.copied);
  }
}

/// Allergies on red, the first thing anyone should read.
class _Allergies extends StatelessWidget {
  const _Allergies({required this.allergies});

  final List<String> allergies;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasAllergies = allergies.isNotEmpty;
    return Semantics(
      container: true,
      child: AppCard(
        raised: false,
        color: hasAllergies
            ? context.colors.overdueSoft
            : context.colors.surfaceMuted,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.sm,
          children: [
            Row(
              spacing: AppSpacing.sm,
              children: [
                Icon(
                  Icons.warning_amber,
                  color: hasAllergies
                      ? context.colors.overdue
                      : context.colors.inkMuted,
                ),
                Text(
                  l10n.allergiesTitle.toUpperCase(),
                  semanticsLabel: l10n.allergiesTitle,
                  style: AppTextStyles.overline.copyWith(
                    color: hasAllergies
                        ? context.colors.overdue
                        : context.colors.inkMuted,
                  ),
                ),
              ],
            ),
            Text(
              hasAllergies ? allergies.join('\n') : l10n.noAllergies,
              style: AppTextStyles.headline.copyWith(
                color: hasAllergies
                    ? context.colors.overdueDark
                    : context.colors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A doctor or relative, with a call button when there is a number.
class _ContactCard extends ConsumerWidget {
  const _ContactCard(this.contact);

  final CareContact contact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return AppCard(
      child: Row(
        spacing: AppSpacing.md,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xxs,
              children: [
                Text(contact.name, style: AppTextStyles.title),
                if (contact.role.isNotEmpty)
                  Text(
                    contact.role,
                    style: AppTextStyles.bodyMuted.copyWith(
                      color: context.colors.inkMuted,
                    ),
                  ),
                if (contact.phone.isNotEmpty)
                  Text(contact.phone, style: AppTextStyles.body),
              ],
            ),
          ),
          if (contact.phone.isNotEmpty)
            IconButton.filled(
              tooltip: l10n.callName(contact.name),
              onPressed: () => _call(context, ref),
              style: IconButton.styleFrom(
                backgroundColor: context.colors.given,
                foregroundColor: context.colors.onAccent,
              ),
              icon: const Icon(Icons.call),
            ),
        ],
      ),
    );
  }

  Future<void> _call(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final called = await ref.read(phoneCallerProvider)(contact.phone);
    if (!called) {
      messenger.showError(l10n.callFailed);
    }
  }
}
