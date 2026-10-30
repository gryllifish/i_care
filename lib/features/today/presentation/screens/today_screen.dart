import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:i_care/core/constants/app_durations.dart';
import 'package:i_care/core/l10n/duration_text.dart';
import 'package:i_care/core/l10n/failure_messages.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/router/app_routes.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_radius.dart';
import 'package:i_care/core/theme/app_shadows.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';
import 'package:i_care/core/utils/formatters.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/data/sample/sample_circle.dart';
import 'package:i_care/features/care/domain/entities/appointment.dart';
import 'package:i_care/features/care/domain/entities/dose_slot.dart';
import 'package:i_care/features/care/domain/entities/stock_level.dart';
import 'package:i_care/features/today/controllers/dose_controller.dart';
import 'package:i_care/features/today/controllers/today_view.dart';
import 'package:i_care/features/today/presentation/widgets/dose_sheet.dart';
import 'package:i_care/features/today/presentation/widgets/dose_texts.dart';
import 'package:i_care/features/today/presentation/widgets/dose_tile.dart';
import 'package:i_care/features/today/presentation/widgets/sync_banner.dart';
import 'package:i_care/shared/l10n/date_texts.dart';
import 'package:i_care/shared/providers/now_provider.dart';
import 'package:i_care/shared/widgets/app_card.dart';
import 'package:i_care/shared/widgets/caregiver_avatar.dart';
import 'package:i_care/shared/widgets/caregiver_choices.dart';
import 'package:i_care/shared/widgets/date_badge.dart';
import 'package:i_care/shared/widgets/error_view.dart';
import 'package:i_care/shared/widgets/screen_header.dart';

/// Today's doses: what is next, what is late and who did what.
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(todayViewProvider, (previous, next) {
      // Conflicts already there when the screen opens show in the list;
      // only ones that arrive with a sync interrupt.
      final before = previous?.value?.conflicts;
      final after = next.value?.conflicts;
      if (before == null || after == null) return;
      final known = {for (final item in before) item.conflict.key};
      final arrived = after.where((item) => !known.contains(item.conflict.key));
      if (arrived.firstOrNull case final item?) {
        _announceConflict(context, item);
      }
    });

    return SafeArea(
      bottom: false,
      child: switch (ref.watch(todayViewProvider)) {
        AsyncData(:final value) => _TodayContent(view: value),
        AsyncError(:final error) => ErrorView(
          message: context.l10n.errorMessage(error),
          onRetry: () => ref.invalidate(careLogProvider),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

/// Interrupts with a conflict that just arrived, replacing any other
/// message: it matters more than a confirmation.
void _announceConflict(BuildContext context, ConflictItem item) {
  final l10n = context.l10n;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(l10n.conflictArrived(item.medication.details.name)),
        duration: AppDurations.conflictNotice,
        action: SnackBarAction(
          label: l10n.review,
          onPressed: () => _openConflict(context, item),
        ),
      ),
    );
}

Future<void> _openConflict(BuildContext context, ConflictItem item) =>
    showDoseSheet(
      context,
      medicationId: item.medication.id,
      slotAt: item.slotAt,
    );

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
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        AppSpacing.lg,
        AppSpacing.screenHorizontal,
        AppSpacing.xxl,
      ),
      children: [
        _Header(day: view.day),
        const SizedBox(height: AppSpacing.lg),
        _DayProgress(done: view.resolvedToday, total: view.totalToday),
        for (final item in view.conflicts) ...[
          const SizedBox(height: AppSpacing.md),
          _ConflictCard(item: item, onTap: () => _openConflict(context, item)),
        ],
        if (next != null) ...[
          const SizedBox(height: AppSpacing.lg),
          _NextDoseCard(
            slot: next,
            isFromYesterday: next.slotAt.isBefore(view.day),
            onOpen: () => open(next),
          ),
        ],
        if (view.nextAppointment case final appointment?) ...[
          const SizedBox(height: AppSpacing.lg),
          _NextAppointmentCard(appointment: appointment),
        ],
        if (view.fromYesterday.isNotEmpty)
          _Timeline(
            title: l10n.fromYesterday,
            slots: view.fromYesterday,
            stock: view.stock,
            onOpen: open,
          ),
        for (final MapEntry(key: part, value: slots) in view.byDayPart.entries)
          _Timeline(
            title: part.label(l10n),
            slots: slots,
            stock: view.stock,
            onOpen: open,
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
        const SizedBox(height: AppSpacing.xl),
        const _HandoffCard(),
        const SizedBox(height: AppSpacing.md),
        const _Disclaimer(),
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

class _Header extends StatelessWidget {
  const _Header({required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return ScreenHeader(
      leading: const _RecipientAvatar(),
      overline: l10n.caringFor,
      title: SampleCircle.recipientName,
      subtitle: Formatters.longDay(day, locale),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _TeamButton(),
          IconButton(
            tooltip: l10n.settingsTitle,
            onPressed: () => context.push(AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      footer: const Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [_EmergencyCardButton(), SyncBanner(), _SampleDataPill()],
      ),
    );
  }
}

class _RecipientAvatar extends StatelessWidget {
  const _RecipientAvatar();

  static const _size = 52.0;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: CircleAvatar(
        radius: _size / 2,
        backgroundColor: context.colors.recipient,
        child: Text(
          SampleCircle.recipientName.characters.first,
          style: AppTextStyles.headline.copyWith(
            color: context.colors.onAccent,
          ),
        ),
      ),
    );
  }
}

/// Opens the emergency card: one tap from the first screen, for the
/// moment someone needs it at a hospital.
class _EmergencyCardButton extends StatelessWidget {
  const _EmergencyCardButton();

  static const _iconSize = 18.0;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: Material(
        color: context.colors.overdueSoft,
        shape: const StadiumBorder(),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: () => context.push(AppRoutes.emergency),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: kMinInteractiveDimension,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: AppSpacing.xs,
                children: [
                  Icon(
                    Icons.medical_information,
                    size: _iconSize,
                    color: context.colors.overdue,
                  ),
                  Flexible(
                    child: Text(
                      context.l10n.emergencyCard,
                      style: AppTextStyles.pill.copyWith(
                        color: context.colors.overdue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SampleDataPill extends StatelessWidget {
  const _SampleDataPill();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.surfaceMuted,
          borderRadius: AppRadius.pillBorder,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs + AppSpacing.xxs,
          ),
          child: Text(
            context.l10n.sampleData,
            style: AppTextStyles.pill.copyWith(color: context.colors.inkMuted),
          ),
        ),
      ),
    );
  }
}

/// The circle's members as overlapping avatars, the current one first.
/// Tapping switches who is recording on this phone.
class _TeamButton extends ConsumerWidget {
  const _TeamButton();

  static const _avatarSize = 40.0;
  static const _overlap = 12.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(currentCaregiverProvider);
    final members = [
      current,
      for (final caregiver in ref.watch(caregiversProvider))
        if (caregiver != current) caregiver,
    ];
    const step = _avatarSize - _overlap;

    return Semantics(
      label: '${context.l10n.whoAreYou} ${current.name}',
      button: true,
      excludeSemantics: true,
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (_) => const _CaregiverPicker(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: SizedBox(
            width: _avatarSize + (members.length - 1) * step,
            height: _avatarSize,
            child: Stack(
              children: [
                // Painted last to first, so the current caregiver is on top.
                for (final (index, caregiver)
                    in members.indexed.toList().reversed)
                  Positioned(
                    left: index * step,
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.xxs),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.colors.background,
                      ),
                      child: CaregiverAvatar(
                        caregiver: caregiver,
                        size: _avatarSize - AppSpacing.xs,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CaregiverPicker extends StatelessWidget {
  const _CaregiverPicker();

  @override
  Widget build(BuildContext context) {
    // Scrolls when large text makes the list taller than the screen.
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.sm,
          children: [
            Text(context.l10n.whoAreYou, style: AppTextStyles.headline),
            CaregiverChoices(onChosen: () => Navigator.of(context).pop()),
          ],
        ),
      ),
    );
  }
}

class _DayProgress extends StatelessWidget {
  const _DayProgress({required this.done, required this.total});

  final int done;
  final int total;

  static const _barHeight = 10.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDone = total > 0 && done >= total;
    final color = isDone ? context.colors.given : context.colors.teal;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.md,
        children: [
          Row(
            spacing: AppSpacing.sm,
            children: [
              Icon(
                isDone ? Icons.check_circle : Icons.donut_large,
                color: color,
              ),
              Expanded(
                child: Text(
                  isDone ? l10n.dayDone : l10n.dayProgress(done, total),
                  style: AppTextStyles.label,
                ),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: AppRadius.pillBorder,
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : done / total,
              minHeight: _barHeight,
              color: color,
              backgroundColor: context.colors.surfaceMuted,
            ),
          ),
        ],
      ),
    );
  }
}

/// The dose to attend to first, with the main action one tap away.
class _NextDoseCard extends ConsumerStatefulWidget {
  const _NextDoseCard({
    required this.slot,
    required this.isFromYesterday,
    required this.onOpen,
  });

  final DoseSlot slot;
  final bool isFromYesterday;
  final VoidCallback onOpen;

  @override
  ConsumerState<_NextDoseCard> createState() => _NextDoseCardState();
}

class _NextDoseCardState extends ConsumerState<_NextDoseCard> {
  var _busy = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final now = ref.watch(nowProvider);
    final slot = widget.slot;
    final details = slot.medication.details;
    final isLate = slot.status == DoseStatus.overdue;
    final colors = context.colors;

    final overline = switch (slot.status) {
      _ when widget.isFromYesterday => l10n.nextFromYesterday,
      DoseStatus.overdue => l10n.nextLate(
        l10n.duration(now.difference(slot.slotAt)),
      ),
      DoseStatus.due => l10n.nextDueNow,
      _ => l10n.nextIn(l10n.duration(slot.slotAt.difference(now))),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isLate ? colors.heroLate : colors.hero,
        ),
        boxShadow: AppShadows.hero(colors),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.xl,
          AppSpacing.xl,
          AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.sm,
          children: [
            Row(
              spacing: AppSpacing.sm,
              children: [
                Icon(
                  isLate ? Icons.warning_amber : Icons.schedule,
                  color: colors.onHero,
                ),
                Expanded(
                  child: Text(
                    overline.toUpperCase(),
                    semanticsLabel: overline,
                    style: AppTextStyles.overline.copyWith(
                      color: colors.onHeroMuted,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              '${Formatters.time(slot.slotAt, locale)} · ${details.name}',
              style: AppTextStyles.headline.copyWith(
                color: colors.onHero,
              ),
            ),
            Text(
              [
                details.strength,
                if (details.instructions.isNotEmpty) details.instructions,
              ].join(' · '),
              style: AppTextStyles.body.copyWith(
                color: colors.onHeroMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            FilledButton.icon(
              onPressed: _busy ? null : _give,
              style: FilledButton.styleFrom(
                backgroundColor: colors.onHero,
                foregroundColor: (isLate ? colors.heroLate : colors.hero).first,
              ),
              icon: const Icon(Icons.check),
              label: Text(l10n.markGiven),
            ),
            TextButton(
              onPressed: widget.onOpen,
              style: TextButton.styleFrom(
                foregroundColor: colors.onHero,
              ),
              child: Text(l10n.moreOptions),
            ),
          ],
        ),
      ),
    );
  }

  /// Gives the dose right away when there is nothing to check first;
  /// otherwise opens the sheet, so warnings are always seen.
  Future<void> _give() async {
    final slot = widget.slot;
    final detail = ref
        .read(doseDetailProvider(slot.medication.id, slot.slotAt))
        .value;
    if (detail == null || detail.warnings.isNotEmpty) {
      widget.onOpen();
      return;
    }
    setState(() => _busy = true);
    await recordDoseGiven(context, ref, detail: detail, slotAt: slot.slotAt);
    if (mounted) setState(() => _busy = false);
  }
}

/// The next appointment, when it is close; opens it in its tab.
class _NextAppointmentCard extends ConsumerWidget {
  const _NextAppointmentCard({required this.appointment});

  final Appointment appointment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final details = appointment.details;
    final questions = details.questionList.length;
    return AppCard(
      onTap: () => context.go(AppRoutes.appointmentPath(appointment.id)),
      child: Row(
        spacing: AppSpacing.md,
        children: [
          DateBadge(day: appointment.startsAt),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xxs,
              children: [
                Text(
                  l10n.nextAppointment.toUpperCase(),
                  semanticsLabel: l10n.nextAppointment,
                  style: AppTextStyles.overline.copyWith(
                    color: context.colors.inkMuted,
                  ),
                ),
                Text(details.title, style: AppTextStyles.title),
                Text(
                  [
                    appointmentWhen(
                      l10n,
                      appointment.startsAt,
                      now: ref.watch(nowProvider),
                      locale: locale,
                    ),
                    if (questions > 0) l10n.questionsCount(questions),
                  ].join(' · '),
                  style: AppTextStyles.bodyMuted.copyWith(
                    color: context.colors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: context.colors.inkMuted),
        ],
      ),
    );
  }
}

/// A dose recorded more than once, at the top of Today until reviewed.
class _ConflictCard extends ConsumerWidget {
  const _ConflictCard({required this.item, required this.onTap});

  final ConflictItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Semantics(
      container: true,
      liveRegion: true,
      child: AppCard(
        color: context.colors.overdueSoft,
        raised: false,
        onTap: onTap,
        child: Row(
          spacing: AppSpacing.md,
          children: [
            Icon(Icons.error, color: context.colors.overdue),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.xs,
                children: [
                  Text(
                    item.title(l10n, locale),
                    style: AppTextStyles.label.copyWith(
                      color: context.colors.overdue,
                    ),
                  ),
                  Text(
                    conflictRecordsText(
                      l10n,
                      item: item,
                      caregivers: ref.watch(caregiversByIdProvider),
                      today: ref.watch(nowProvider),
                      locale: locale,
                    ),
                    style: AppTextStyles.body,
                  ),
                ],
              ),
            ),
            Text(
              l10n.review,
              style: AppTextStyles.label.copyWith(
                color: context.colors.overdue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A part of the day as a section of the timeline.
class _Timeline extends StatelessWidget {
  const _Timeline({
    required this.title,
    required this.slots,
    required this.stock,
    required this.onOpen,
  });

  final String title;
  final List<DoseSlot> slots;
  final Map<String, StockLevel> stock;
  final ValueChanged<DoseSlot> onOpen;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: title,
      spacing: 0,
      children: [
        for (final (index, slot) in slots.indexed)
          DoseTile(
            slot: slot,
            stock: stock[slot.medication.id],
            isFirst: index == 0,
            isLast: index == slots.length - 1,
            onTap: () => onOpen(slot),
          ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.children,
    this.spacing = AppSpacing.sm,
  });

  final String title;
  final List<Widget> children;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: spacing,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Semantics(
              container: true,
              header: true,
              child: Text(title, style: AppTextStyles.title),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

/// Opens the handoff summary for whoever takes over next.
class _HandoffCard extends StatelessWidget {
  const _HandoffCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppCard(
      onTap: () => context.push(AppRoutes.handoff),
      child: Row(
        spacing: AppSpacing.md,
        children: [
          Icon(Icons.forum_outlined, color: context.colors.teal),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.xxs,
              children: [
                Text(l10n.handoffTitle, style: AppTextStyles.label),
                Text(
                  l10n.handoffSubtitle,
                  style: AppTextStyles.bodyMuted.copyWith(
                    color: context.colors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: context.colors.inkMuted),
        ],
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      raised: false,
      color: context.colors.surfaceMuted,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.md,
        children: [
          Icon(Icons.info_outline, color: context.colors.inkMuted),
          Expanded(
            child: Text(
              context.l10n.medicalDisclaimer,
              style: AppTextStyles.bodyMuted.copyWith(
                color: context.colors.inkMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
