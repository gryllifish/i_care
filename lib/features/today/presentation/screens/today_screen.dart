import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_radius.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/core/utils/formatters.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/data/sample/sample_circle.dart';
import 'package:i_care/features/care/domain/entities/dose_slot.dart';
import 'package:i_care/features/today/controllers/today_view.dart';
import 'package:i_care/features/today/presentation/widgets/dose_sheet.dart';
import 'package:i_care/features/today/presentation/widgets/dose_status_style.dart';
import 'package:i_care/features/today/presentation/widgets/dose_tile.dart';
import 'package:i_care/features/today/presentation/widgets/sync_banner.dart';
import 'package:i_care/shared/widgets/caregiver_avatar.dart';
import 'package:i_care/shared/widgets/error_view.dart';

/// Today's doses: what is next, what is late and who did what.
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: switch (ref.watch(todayViewProvider)) {
          AsyncData(:final value) => _TodayContent(view: value),
          AsyncError(:final error) => ErrorView(
            message: context.l10n.errorMessage(error),
            onRetry: () => ref.invalidate(careLogProvider),
          ),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class _TodayContent extends StatelessWidget {
  const _TodayContent({required this.view});

  final TodayView view;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final next = view.next;

    void open(DoseSlot slot) => showDoseSheet(
      context,
      medicationId: slot.medication.id,
      slotAt: slot.slotAt,
    );

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.xl,
      ),
      children: [
        _Header(day: view.day),
        const SizedBox(height: AppSpacing.md),
        const SyncBanner(),
        if (view.conflicts.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          _ReviewBanner(count: view.conflicts.length),
        ],
        const SizedBox(height: AppSpacing.xl),
        if (next != null)
          _NextDoseCard(
            slot: next,
            isFromYesterday: next.slotAt.isBefore(view.day),
            onTap: () => open(next),
          )
        else
          Text(l10n.allDoneToday, style: AppTextStyles.body),
        if (view.fromYesterday.isNotEmpty)
          _Section(
            title: l10n.fromYesterday,
            children: [
              for (final slot in view.fromYesterday)
                DoseTile(slot: slot, onTap: () => open(slot)),
            ],
          ),
        for (final MapEntry(key: part, value: slots) in view.byDayPart.entries)
          _Section(
            title: part.label(l10n),
            children: [
              for (final slot in slots)
                DoseTile(
                  slot: slot,
                  stock: view.stock[slot.medication.id],
                  onTap: () => open(slot),
                ),
            ],
          ),
        if (view.asNeeded.isNotEmpty)
          _Section(
            title: l10n.asNeeded,
            children: [
              for (final item in view.asNeeded)
                AsNeededTile(
                  item: item,
                  onTap: () => showDoseSheet(
                    context,
                    medicationId: item.medication.id,
                    slotAt: null,
                  ),
                ),
            ],
          ),
        const SizedBox(height: AppSpacing.xxl),
        Text(l10n.medicalDisclaimer, style: AppTextStyles.bodyMuted),
      ],
    );
  }
}

extension on DayPart {
  String label(AppLocalizations l10n) => switch (this) {
    DayPart.morning => l10n.dayPartMorning,
    DayPart.midday => l10n.dayPartMidday,
    DayPart.afternoon => l10n.dayPartAfternoon,
    DayPart.night => l10n.dayPartNight,
  };
}

class _Header extends ConsumerWidget {
  const _Header({required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSpacing.xs,
            children: [
              Text(l10n.todayTitle, style: AppTextStyles.headline),
              Text(Formatters.longDay(day, locale), style: AppTextStyles.body),
              Text(
                '${l10n.careOf(SampleCircle.recipientName)} · '
                '${l10n.sampleData}',
                style: AppTextStyles.bodyMuted,
              ),
            ],
          ),
        ),
        const _CaregiverButton(),
      ],
    );
  }
}

/// Shows who is recording on this phone and lets them switch.
class _CaregiverButton extends ConsumerWidget {
  const _CaregiverButton();

  static const _avatarSize = 40.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(currentCaregiverProvider);
    final l10n = context.l10n;
    return Semantics(
      label: '${l10n.whoAreYou} ${current.name}',
      button: true,
      excludeSemantics: true,
      child: IconButton(
        tooltip: l10n.whoAreYou,
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          showDragHandle: true,
          builder: (_) => const _CaregiverPicker(),
        ),
        icon: CaregiverAvatar(caregiver: current, size: _avatarSize),
      ),
    );
  }
}

class _CaregiverPicker extends ConsumerWidget {
  const _CaregiverPicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(currentCaregiverProvider);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.l10n.whoAreYou, style: AppTextStyles.title),
          const SizedBox(height: AppSpacing.sm),
          for (final caregiver in ref.watch(caregiversProvider))
            ListTile(
              leading: CaregiverAvatar(caregiver: caregiver),
              title: Text(caregiver.name, style: AppTextStyles.body),
              selected: caregiver == current,
              trailing: caregiver == current ? const Icon(Icons.check) : null,
              onTap: () {
                ref.read(currentCaregiverProvider.notifier).select(caregiver);
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
    );
  }
}

class _NextDoseCard extends StatelessWidget {
  const _NextDoseCard({
    required this.slot,
    required this.isFromYesterday,
    required this.onTap,
  });

  final DoseSlot slot;
  final bool isFromYesterday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final style = slot.style(l10n);
    final details = slot.medication.details;

    return Semantics(
      button: true,
      child: Material(
        color: style.background,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.sm,
              children: [
                Text(l10n.nextDose, style: AppTextStyles.bodyMuted),
                Text(
                  '${isFromYesterday ? '${l10n.yesterday} ' : ''}'
                  '${Formatters.time(slot.slotAt, locale)} · '
                  '${details.name} ${details.strength}',
                  style: AppTextStyles.title,
                ),
                if (details.instructions.isNotEmpty)
                  Text(details.instructions, style: AppTextStyles.body),
                Row(
                  spacing: AppSpacing.sm,
                  children: [
                    Icon(style.icon, color: style.color),
                    Text(
                      style.label,
                      style: AppTextStyles.label.copyWith(color: style.color),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReviewBanner extends StatelessWidget {
  const _ReviewBanner({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.overdueSoft,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          spacing: AppSpacing.sm,
          children: [
            const Icon(Icons.error, color: AppColors.overdue),
            Expanded(
              child: Text(
                context.l10n.toReview(count),
                style: AppTextStyles.label.copyWith(color: AppColors.overdue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.sm,
        children: [
          Semantics(
            header: true,
            child: Text(title, style: AppTextStyles.title),
          ),
          ...children,
        ],
      ),
    );
  }
}
