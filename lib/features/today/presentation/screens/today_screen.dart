import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:i_care/core/constants/app_durations.dart';
import 'package:i_care/core/error/result.dart';
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
import 'package:i_care/features/care/domain/entities/dose_slot.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';
import 'package:i_care/features/care/domain/entities/task_slot.dart';
import 'package:i_care/features/care/domain/permissions.dart';
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
import 'package:i_care/shared/widgets/error_view.dart';
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

/// Today in order of what to do: anything to review, the one thing to do
/// now, notes and the next appointment in a line each, then the day's
/// list.
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

    Future<void> syncNow() async {
      final messenger = ScaffoldMessenger.of(context);
      final result = await ref.read(syncActionsProvider.notifier).syncNow();
      if (result case Err(:final failure)) {
        messenger.showError(failure.message(l10n));
      }
    }

    return RefreshIndicator.adaptive(
      onRefresh: syncNow,
      child: ListView(
        // Pulls to sync even when the day fits on screen.
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenHorizontal,
          AppSpacing.lg,
          AppSpacing.screenHorizontal,
          AppSpacing.xxl,
        ),
        children: [
          _Header(day: view.day),
          if (view.conflicts.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            _ToReview(items: view.conflicts),
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
          const SizedBox(height: AppSpacing.lg),
          _Links(view: view),
          _DayList(
            view: view,
            // Already the focus above: listing it again is noise.
            focused: summary ? null : next,
            onOpenDose: open,
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
        ],
      ),
    );
  }
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
      subtitle: Formatters.weekdayAndDate(day, locale),
      trailing: IconButton(
        tooltip: l10n.settingsTitle,
        onPressed: () => context.push(AppRoutes.settings),
        icon: const Icon(Icons.settings_outlined),
      ),
      footer: const SyncBanner(),
    );
  }
}

/// The care recipient's initial, which opens their emergency card: one
/// tap from the first screen, for the moment someone needs it at a
/// hospital.
class _RecipientAvatar extends StatelessWidget {
  const _RecipientAvatar({required this.name});

  final String name;

  static const _size = 52.0;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: context.l10n.emergencyCard,
      child: Semantics(
        button: true,
        label: context.l10n.emergencyCard,
        excludeSemantics: true,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => context.push(AppRoutes.emergency),
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
        ),
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
              style: AppTextStyles.headline.copyWith(color: colors.onHero),
            ),
            Text(
              [
                details.strength,
                if (details.instructions.isNotEmpty) details.instructions,
              ].join(' · '),
              style: AppTextStyles.body.copyWith(color: colors.onHeroMuted),
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
              style: TextButton.styleFrom(foregroundColor: colors.onHero),
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

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.children,
    this.trailing,
    this.spacing = AppSpacing.sm,
  });

  final String title;

  /// A short count beside the title.
  final String? trailing;
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
            // The count drops below the title when large text needs it.
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.end,
              spacing: AppSpacing.sm,
              children: [
                Semantics(
                  container: true,
                  header: true,
                  child: Text(title, style: AppTextStyles.title),
                ),
                if (trailing case final String trailing)
                  Text(
                    trailing,
                    style: AppTextStyles.bodyMuted.copyWith(
                      color: context.colors.inkMuted,
                    ),
                  ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

/// Doses recorded more than once, as one line however many: opens the
/// one, or a list to pick from.
class _ToReview extends StatelessWidget {
  const _ToReview({required this.items});

  final List<ConflictItem> items;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      container: true,
      liveRegion: true,
      child: AppCard(
        color: colors.overdueSoft,
        raised: false,
        onTap: () => items.length == 1
            ? _openConflict(context, items.single)
            : _showConflicts(context, items),
        child: Row(
          spacing: AppSpacing.md,
          children: [
            Icon(Icons.error, color: colors.overdue),
            Expanded(
              child: Text(
                context.l10n.toReview(items.length),
                style: AppTextStyles.label.copyWith(color: colors.overdue),
              ),
            ),
            Icon(Icons.chevron_right, color: colors.overdue),
          ],
        ),
      ),
    );
  }
}

Future<void> _showConflicts(BuildContext context, List<ConflictItem> items) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheet) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.md,
            children: [
              Text(
                sheet.l10n.toReview(items.length),
                style: AppTextStyles.headline,
              ),
              for (final item in items)
                _ConflictCard(
                  item: item,
                  onTap: () {
                    Navigator.of(sheet).pop();
                    unawaited(_openConflict(context, item));
                  },
                ),
            ],
          ),
        ),
      ),
    );

/// Notes left for the circle and the next appointment, a line each.
class _Links extends ConsumerWidget {
  const _Links({required this.view});

  final TodayView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final notes = view.recentNotes;
    final latest = notes.firstOrNull;
    final appointment = view.nextAppointment;
    final canLeave = ref.watch(canDoProvider(CareAction.leaveNote));
    final rows = [
      if (latest != null || canLeave)
        _LinkRow(
          icon: Icons.forum_outlined,
          title: [
            l10n.handoffTitle,
            if (notes.isNotEmpty) l10n.notesCount(notes.length),
          ].join(' · '),
          detail: latest == null
              ? l10n.notesRowEmpty
              : l10n.notePreview(
                  ref
                          .watch(membersByIdProvider)[latest.meta.caregiverId]
                          ?.name ??
                      l10n.unknownCaregiver,
                  latest.text,
                ),
          onTap: () => context.push(AppRoutes.handoff),
        ),
      if (appointment != null)
        _LinkRow(
          icon: Icons.event_outlined,
          title: appointment.details.title,
          detail: appointmentWhen(
            l10n,
            appointment.startsAt,
            now: ref.watch(nowProvider),
            locale: locale,
          ),
          onTap: () => context.push(AppRoutes.appointmentPath(appointment.id)),
        ),
    ];
    if (rows.isEmpty) return const SizedBox.shrink();
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (final (index, row) in rows.indexed) ...[
            if (index > 0) const Divider(height: 1),
            row,
          ],
        ],
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.icon,
    required this.title,
    required this.detail,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String detail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          spacing: AppSpacing.md,
          children: [
            Icon(icon, color: colors.teal),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.xxs,
                children: [
                  Text(title, style: AppTextStyles.label),
                  Text(
                    detail,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMuted.copyWith(
                      color: colors.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: colors.inkMuted),
          ],
        ),
      ),
    );
  }
}

/// The day's list: what is still to do by time, with what is already
/// done folded into one line that opens it.
class _DayList extends StatefulWidget {
  const _DayList({
    required this.view,
    required this.focused,
    required this.onOpenDose,
  });

  final TodayView view;

  /// The dose shown as the focus, left out of the list.
  final DoseSlot? focused;
  final ValueChanged<DoseSlot> onOpenDose;

  @override
  State<_DayList> createState() => _DayListState();
}

class _DayListState extends State<_DayList> {
  var _showResolved = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final view = widget.view;
    final resolved = view.resolved;
    final total =
        view.pending.length + view.pendingAnyTime.length + resolved.length;

    Widget tile(
      TimelineEntry entry, {
      required bool first,
      required bool last,
    }) => switch (entry) {
      DoseEntry(:final slot) => DoseTile(
        slot: slot,
        stock: view.stock[slot.medication.id],
        isFirst: first,
        isLast: last,
        onTap: () => widget.onOpenDose(slot),
      ),
      TaskEntry(:final slot) when slot.isAnyTime => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: TaskCard(slot: slot, onTap: () => _openTask(context, slot)),
      ),
      TaskEntry(:final slot) => TaskTile(
        slot: slot,
        isFirst: first,
        isLast: last,
        onTap: () => _openTask(context, slot),
      ),
    };

    List<Widget> rail(List<TimelineEntry> entries) => [
      for (final (index, entry) in entries.indexed)
        tile(entry, first: index == 0, last: index == entries.length - 1),
    ];

    return _Section(
      title: l10n.today,
      trailing: total == 0 ? null : l10n.doneOfTotal(resolved.length, total),
      spacing: 0,
      children: [
        if (total == 0)
          Text(
            l10n.nothingToday,
            style: AppTextStyles.bodyMuted.copyWith(
              color: context.colors.inkMuted,
            ),
          ),
        if (resolved.isNotEmpty) ...[
          _ResolvedToggle(
            count: resolved.length,
            expanded: _showResolved,
            onTap: () => setState(() => _showResolved = !_showResolved),
          ),
          if (_showResolved) ...rail(resolved),
        ],
        ...rail([
          for (final entry in view.pending)
            if (!(entry is DoseEntry && entry.slot == widget.focused)) entry,
        ]),
        if (view.pendingAnyTime.isNotEmpty)
          _AnyTimeTasks(slots: view.pendingAnyTime),
      ],
    );
  }
}

class _ResolvedToggle extends StatelessWidget {
  const _ResolvedToggle({
    required this.count,
    required this.expanded,
    required this.onTap,
  });

  final int count;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Semantics(
        button: true,
        expanded: expanded,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.pillBorder,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: kMinInteractiveDimension,
            ),
            child: Row(
              spacing: AppSpacing.sm,
              children: [
                Icon(Icons.check_circle, color: colors.given),
                Expanded(
                  child: Text(
                    context.l10n.resolvedCount(count),
                    style: AppTextStyles.label,
                  ),
                ),
                Icon(
                  expanded ? Icons.expand_less : Icons.expand_more,
                  color: colors.inkMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Today's untimed tasks still to do, as one line of chips.
class _AnyTimeTasks extends StatelessWidget {
  const _AnyTimeTasks({required this.slots});

  final List<TaskSlot> slots;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.sm,
        children: [
          Text(
            context.l10n.duringTheDay,
            style: AppTextStyles.label.copyWith(color: context.colors.inkMuted),
          ),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final slot in slots)
                ActionChip(
                  avatar: const Icon(Icons.volunteer_activism_outlined),
                  label: Text(slot.task.details.name),
                  onPressed: () => _openTask(context, slot),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
