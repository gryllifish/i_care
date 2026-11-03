import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:i_care/features/care/domain/entities/appointment.dart';
import 'package:i_care/features/care/domain/entities/dose_slot.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';
import 'package:i_care/features/care/domain/entities/stock_level.dart';
import 'package:i_care/features/care/domain/entities/task_slot.dart';
import 'package:i_care/features/today/controllers/dose_controller.dart';
import 'package:i_care/features/today/controllers/today_view.dart';
import 'package:i_care/features/today/presentation/widgets/dose_sheet.dart';
import 'package:i_care/features/today/presentation/widgets/dose_texts.dart';
import 'package:i_care/features/today/presentation/widgets/dose_tile.dart';
import 'package:i_care/features/today/presentation/widgets/sync_banner.dart';
import 'package:i_care/features/today/presentation/widgets/task_sheet.dart';
import 'package:i_care/features/today/presentation/widgets/task_tile.dart';
import 'package:i_care/shared/l10n/date_texts.dart';
import 'package:i_care/shared/l10n/event_text.dart';
import 'package:i_care/shared/providers/now_provider.dart';
import 'package:i_care/shared/widgets/app_card.dart';
import 'package:i_care/shared/widgets/app_snack_bars.dart';
import 'package:i_care/shared/widgets/date_badge.dart';
import 'package:i_care/shared/widgets/error_view.dart';
import 'package:i_care/shared/widgets/member_avatar.dart';
import 'package:i_care/shared/widgets/member_list.dart';
import 'package:i_care/shared/widgets/screen_header.dart';
import 'package:i_care/shared/widgets/status_pill.dart';

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
    ..showMessage(
      l10n.conflictArrived(item.medication.details.name),
      action: SnackBarAction(
        label: l10n.review,
        onPressed: () => _openConflict(context, item),
      ),
    );
}

Future<void> _openTask(BuildContext context, TaskSlot slot) =>
    showTaskSheet(context, taskId: slot.task.id, slotAt: slot.slotAt);

Future<void> _openConflict(BuildContext context, ConflictItem item) =>
    showDoseSheet(
      context,
      medicationId: item.medication.id,
      slotAt: item.slotAt,
    );

class _TodayContent extends ConsumerWidget {
  const _TodayContent({required this.view});

  final TodayView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final next = view.next;
    final role = ref.watch(currentMemberProvider)?.role;
    final summary = role != null && showsDaySummary(role);

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
        if (summary) ...[
          const SizedBox(height: AppSpacing.lg),
          _DaySummaryCard(view: view),
        ] else
          _NextDoseSwitcher(
            child: switch ((next, view.nextLater)) {
              (final DoseSlot next, _) => Padding(
                // One card per dose: a new one animates in.
                key: ValueKey((next.medication.id, next.slotAt)),
                padding: const EdgeInsets.only(top: AppSpacing.lg),
                child: _NextDoseCard(
                  slot: next,
                  isFromYesterday: next.slotAt.isBefore(view.day),
                  onOpen: () => open(next),
                ),
              ),
              (null, (:final medication, :final at)) => Padding(
                key: ValueKey((medication.id, at)),
                padding: const EdgeInsets.only(top: AppSpacing.lg),
                child: _NextLaterCard(medication: medication, at: at),
              ),
              (null, null) => null,
            },
          ),
        if (view.nextAppointment case final appointment?) ...[
          const SizedBox(height: AppSpacing.lg),
          _NextAppointmentCard(appointment: appointment),
        ],
        if (view.fromYesterday.isNotEmpty)
          _Timeline(
            title: l10n.fromYesterday,
            entries: [
              for (final slot in view.fromYesterday) TimelineEntry.dose(slot),
            ],
            stock: view.stock,
            onOpen: open,
          ),
        if (view.anyTimeTasks.isNotEmpty)
          _Section(
            title: l10n.duringTheDay,
            children: [
              for (final slot in view.anyTimeTasks)
                TaskCard(slot: slot, onTap: () => _openTask(context, slot)),
            ],
          ),
        for (final MapEntry(key: part, value: entries)
            in view.byDayPart.entries)
          _Timeline(
            title: part.label(l10n),
            entries: entries,
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

class _Header extends ConsumerWidget {
  const _Header({required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final name = ref.watch(recipientNameProvider) ?? l10n.theRecipient;
    return ScreenHeader(
      leading: _RecipientAvatar(name: name),
      overline: l10n.caringFor,
      title: name,
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
      footer: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          const _EmergencyCardButton(),
          const SyncBanner(),
          if (ref.watch(isSampleCircleProvider)) const _SampleDataPill(),
        ],
      ),
    );
  }
}

class _RecipientAvatar extends StatelessWidget {
  const _RecipientAvatar({required this.name});

  final String name;

  static const _size = 52.0;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: CircleAvatar(
        radius: _size / 2,
        backgroundColor: context.colors.recipient,
        child: Text(
          name.characters.first.toUpperCase(),
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

/// The circle's members as overlapping avatars, this phone's first.
/// Tapping shows the circle with everyone's role.
class _TeamButton extends ConsumerWidget {
  const _TeamButton();

  static const _avatarSize = 40.0;
  static const _overlap = 12.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(currentMemberProvider);
    final members = [
      ?current,
      for (final member in ref.watch(membersProvider))
        if (member != current) member,
    ];
    if (members.isEmpty) return const SizedBox.shrink();
    const step = _avatarSize - _overlap;

    return Semantics(
      label: context.l10n.circleButtonLabel(current?.name ?? ''),
      button: true,
      excludeSemantics: true,
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (_) => const _CircleSheet(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: SizedBox(
            width: _avatarSize + (members.length - 1) * step,
            height: _avatarSize,
            child: Stack(
              children: [
                // Painted last to first, so this phone's member is on top.
                for (final (index, member) in members.indexed.toList().reversed)
                  Positioned(
                    left: index * step,
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.xxs),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.colors.background,
                      ),
                      child: MemberAvatar(
                        member: member,
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

class _CircleSheet extends StatelessWidget {
  const _CircleSheet();

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
            Text(context.l10n.circleTitle, style: AppTextStyles.headline),
            const MemberList(),
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
                  switch ((total, isDone)) {
                    (0, _) => l10n.dayNothingScheduled,
                    (_, true) => l10n.dayDone,
                    _ => l10n.dayProgress(done, total),
                  },
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

/// How the day is going, for whoever coordinates rather than gives the
/// doses: how much is done, what is late, and the latest record.
class _DaySummaryCard extends ConsumerWidget {
  const _DaySummaryCard({required this.view});

  final TodayView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final colors = context.colors;
    final last = view.lastRecord;
    final author = last == null
        ? null
        : ref.watch(membersByIdProvider)[last.meta.caregiverId];
    final subject = last == null
        ? null
        : ref.watch(careLogProvider).value?.subjectOf(last);

    return Semantics(
      container: true,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.md,
          children: [
            Text(
              l10n.daySummaryTitle.toUpperCase(),
              semanticsLabel: l10n.daySummaryTitle,
              style: AppTextStyles.overline.copyWith(color: colors.inkMuted),
            ),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: [
                if (view.lateCount > 0)
                  StatusPill(
                    icon: Icons.warning_amber,
                    label: l10n.summaryLate(view.lateCount),
                    color: colors.overdue,
                    background: colors.overdueSoft,
                  )
                else
                  StatusPill(
                    icon: Icons.check_circle,
                    label: l10n.summaryNothingLate,
                    color: colors.given,
                    background: colors.givenSoft,
                  ),
                if (view.tasksToday > 0)
                  StatusPill(
                    icon: Icons.volunteer_activism_outlined,
                    label: l10n.summaryTasks(
                      view.tasksResolvedToday,
                      view.tasksToday,
                    ),
                    color: colors.inkMuted,
                    background: colors.surfaceMuted,
                  ),
              ],
            ),
            Text(
              last == null
                  ? l10n.summaryNothingYet
                  : l10n.summaryLast(
                      eventSentence(
                        l10n,
                        event: last,
                        author: author?.name ?? l10n.unknownCaregiver,
                        subject: subject,
                        locale: locale,
                        customReasons: ref.watch(customReasonsProvider),
                      ),
                      Formatters.time(last.meta.occurredAt, locale),
                    ),
              style: AppTextStyles.body,
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows that the next dose changed, as Material's "fade through": the
/// old card fades out where it is, then the new one fades in while
/// growing slightly into place. One after the other, never overlapping,
/// so two cards are never seen at once; when none is left, the space
/// closes. Instant when the system asks to reduce motion.
class _NextDoseSwitcher extends StatelessWidget {
  const _NextDoseSwitcher({required this.child});

  /// Keyed by dose; null when the day is done.
  final Widget? child;

  /// Out over the first part, in over the rest, with no gap between.
  static const _handover = 0.4;
  static const _duration = Duration(milliseconds: 500);
  static const _enterScale = 0.94;

  @override
  Widget build(BuildContext context) {
    final child = this.child;
    // AnimatedSize cannot run for zero time, and nothing needs to move.
    if (context.reduceMotion) return child ?? const SizedBox.shrink();
    final current = child?.key;
    return AnimatedSize(
      duration: _duration,
      curve: AppCurves.emphasized,
      alignment: Alignment.topCenter,
      child: AnimatedSwitcher(
        duration: _duration,
        switchInCurve: const Interval(
          _handover,
          1,
          curve: AppCurves.emphasized,
        ),
        // Runs backwards for the leaving card: done by the handover.
        switchOutCurve: const Interval(1 - _handover, 1, curve: Curves.easeIn),
        layoutBuilder: (current, previous) => Stack(
          alignment: Alignment.topCenter,
          children: [...previous, ?current],
        ),
        // The same widgets whether a card enters or leaves: the switcher
        // rebuilds transitions on every build, and a different shape would
        // recreate the leaving card and lose its "Given".
        transitionBuilder: (card, animation) => FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: card.key == current
                ? Tween<double>(begin: _enterScale, end: 1).animate(animation)
                : const AlwaysStoppedAnimation(1),
            child: card,
          ),
        ),
        child: child ?? const SizedBox(width: double.infinity),
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

  /// Recorded from this card: it says so while it fades out.
  var _given = false;

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
              onPressed: _busy || _given ? null : _give,
              style: FilledButton.styleFrom(
                backgroundColor: colors.onHero,
                foregroundColor: (isLate ? colors.heroLate : colors.hero).first,
                // Given stays as legible as before, not greyed out.
                disabledBackgroundColor: colors.onHero,
                disabledForegroundColor:
                    (isLate ? colors.heroLate : colors.hero).first,
              ),
              icon: Icon(_given ? Icons.check_circle : Icons.check),
              label: Text(_given ? l10n.statusGiven : l10n.markGiven),
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
    final given = await recordDoseGiven(
      context,
      ref,
      detail: detail,
      slotAt: slot.slotAt,
    );
    if (given) unawaited(HapticFeedback.lightImpact());
    if (mounted) {
      setState(() {
        _busy = false;
        _given = given;
      });
    }
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

/// The first dose on a later day, when today has none left to give: a
/// medication added after today's times starts tomorrow.
class _NextLaterCard extends ConsumerWidget {
  const _NextLaterCard({required this.medication, required this.at});

  final Medication medication;
  final DateTime at;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return AppCard(
      child: Row(
        spacing: AppSpacing.md,
        children: [
          Icon(Icons.schedule, color: context.colors.teal),
          Expanded(
            child: Text(
              l10n.nextDoseLater(
                medication.details.name,
                appointmentWhen(
                  l10n,
                  at,
                  now: ref.watch(nowProvider),
                  locale: Localizations.localeOf(context).toLanguageTag(),
                ),
              ),
              style: AppTextStyles.label,
            ),
          ),
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
                      caregivers: ref.watch(membersByIdProvider),
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

/// A part of the day as a section of the timeline: doses and tasks by
/// time.
class _Timeline extends StatelessWidget {
  const _Timeline({
    required this.title,
    required this.entries,
    required this.stock,
    required this.onOpen,
  });

  final String title;
  final List<TimelineEntry> entries;
  final Map<String, StockLevel> stock;
  final ValueChanged<DoseSlot> onOpen;

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: title,
      spacing: 0,
      children: [
        for (final (index, entry) in entries.indexed)
          switch (entry) {
            DoseEntry(:final slot) => DoseTile(
              slot: slot,
              stock: stock[slot.medication.id],
              isFirst: index == 0,
              isLast: index == entries.length - 1,
              onTap: () => onOpen(slot),
            ),
            TaskEntry(:final slot) => TaskTile(
              slot: slot,
              isFirst: index == 0,
              isLast: index == entries.length - 1,
              onTap: () => _openTask(context, slot),
            ),
          },
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
