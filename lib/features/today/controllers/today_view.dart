import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/domain/entities/appointment.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/conflict.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/entities/dose_slot.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/features/care/domain/entities/stock_level.dart';
import 'package:i_care/features/care/domain/entities/task_slot.dart';
import 'package:i_care/features/care/domain/projections/care_log.dart';
import 'package:i_care/shared/providers/now_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'today_view.freezed.dart';
part 'today_view.g.dart';

/// An as-needed medication and its latest dose.
@freezed
abstract class AsNeededItem with _$AsNeededItem {
  const factory AsNeededItem({
    required Medication medication,
    DoseGiven? lastDose,
    StockLevel? stock,
  }) = _AsNeededItem;
}

/// A dose conflict with what the screen needs to describe it.
@freezed
abstract class ConflictItem with _$ConflictItem {
  const factory ConflictItem({
    required DoseConflict conflict,
    required Medication medication,

    /// The scheduled time the doses were for; null for as-needed doses or
    /// doses for different times given too close together.
    DateTime? slotAt,
  }) = _ConflictItem;
}

/// Something due at a time on the day's timeline.
@freezed
sealed class TimelineEntry with _$TimelineEntry {
  const factory TimelineEntry.dose(DoseSlot slot) = DoseEntry;
  const factory TimelineEntry.task(TaskSlot slot) = TaskEntry;

  const TimelineEntry._();

  DateTime get slotAt => switch (this) {
    DoseEntry(:final slot) => slot.slotAt,
    TaskEntry(:final slot) => slot.slotAt,
  };

  /// Given, done or skipped.
  bool get isResolved => switch (this) {
    DoseEntry(:final slot) => slot.isResolved,
    TaskEntry(:final slot) => slot.isResolved,
  };
}

/// Everything the Today screen shows.
@freezed
abstract class TodayView with _$TodayView {
  const factory TodayView({
    required DateTime day,

    /// Today's doses and tasks, and how many are given, done or skipped.
    /// Yesterday's doses are listed but not counted: they are not part of
    /// today's work.
    @Default(0) int totalToday,
    @Default(0) int resolvedToday,

    /// The dose to attend to first: the earliest due or late one, else
    /// the next upcoming one; null when the day is done.
    DoseSlot? next,

    /// When [next] is null, the first dose on a later day within a week,
    /// so a day with nothing left still says what comes next.
    ({Medication medication, DateTime at})? nextLater,

    /// The day's list, still to attend to: yesterday's unresolved doses,
    /// then today's doses and timed tasks by time (at the same time,
    /// doses first).
    @Default(<TimelineEntry>[]) List<TimelineEntry> pending,

    /// Today's tasks with no set time, still to do.
    @Default(<TaskSlot>[]) List<TaskSlot> pendingAnyTime,

    /// The day's list, already given, done or skipped: yesterday's doses
    /// resolved today, then today's by time, then today's tasks with no set
    /// time.
    @Default(<TimelineEntry>[]) List<TimelineEntry> resolved,

    /// For the day's summary: doses and tasks past their time and not
    /// resolved (yesterday's too), today's tasks and how many are done or
    /// skipped, and the latest dose or task record made today.
    @Default(0) int lateCount,
    @Default(0) int tasksToday,
    @Default(0) int tasksResolvedToday,
    CareEvent? lastRecord,
    @Default(<AsNeededItem>[]) List<AsNeededItem> asNeeded,

    /// The next appointment if it is within [upcomingAppointmentWindow].
    Appointment? nextAppointment,

    /// Notes left within [notesHorizon], newest first: what the notes
    /// screen lists.
    @Default(<CareNoteAdded>[]) List<CareNoteAdded> notes,

    /// Stock per medication, for low-stock badges.
    @Default(<String, StockLevel>{}) Map<String, StockLevel> stock,

    /// Dose conflicts nobody has reviewed. Edit conflicts are shown with
    /// the medication they affect.
    @Default(<ConflictItem>[]) List<ConflictItem> conflicts,
  }) = _TodayView;
}

/// How far ahead Today shows the next appointment.
const upcomingAppointmentWindow = Duration(hours: 48);

/// Builds the Today screen's state from the log at [now].
TodayView buildTodayView(CareLog log, DateTime now) {
  final day = DateTime(now.year, now.month, now.day);
  final slots = log.slotsOn(day, now: now);
  final tasks = log.taskSlotsOn(day, now: now);
  final timeline = [
    for (final slot in slots) TimelineEntry.dose(slot),
    for (final slot in tasks)
      if (!slot.isAnyTime) TimelineEntry.task(slot),
  ]..sort(_byTimeDosesFirst);
  final fromYesterday = log.fromYesterday(day, now: now);
  final fromYesterdayEntries = [
    for (final slot in fromYesterday) TimelineEntry.dose(slot),
  ];
  final anyTime = [
    for (final slot in tasks)
      if (slot.isAnyTime) slot,
  ];
  final next =
      [...fromYesterday, ...slots]
          .where(
            (slot) =>
                slot.status == DoseStatus.due ||
                slot.status == DoseStatus.overdue,
          )
          .firstOrNull ??
      slots.where((slot) => slot.status == DoseStatus.upcoming).firstOrNull;

  final lastRecord =
      [
        for (final event in log.events)
          if (event is DoseGiven ||
              event is DoseSkipped ||
              event is TaskDone ||
              event is TaskSkipped)
            if (_isSameDay(event.meta.occurredAt, day)) event,
      ].fold<CareEvent?>(
        null,
        (latest, event) =>
            latest == null ||
                event.meta.occurredAt.isAfter(latest.meta.occurredAt)
            ? event
            : latest,
      );

  return TodayView(
    day: day,
    lateCount:
        [
          ...fromYesterday,
          ...slots,
        ].where((slot) => slot.status == DoseStatus.overdue).length +
        tasks.where((slot) => slot.status == TaskStatus.late).length,
    tasksToday: tasks.length,
    tasksResolvedToday: tasks.where((slot) => slot.isResolved).length,
    lastRecord: lastRecord,
    totalToday: slots.length + tasks.length,
    resolvedToday:
        slots.where((slot) => slot.isResolved).length +
        tasks.where((slot) => slot.isResolved).length,
    next: next,
    nextLater: next == null
        ? _firstDoseFrom(log, DateTime(day.year, day.month, day.day + 1))
        : null,
    pending: [
      for (final entry in fromYesterdayEntries)
        if (!entry.isResolved) entry,
      for (final entry in timeline)
        if (!entry.isResolved) entry,
    ],
    pendingAnyTime: [
      for (final slot in anyTime)
        if (!slot.isResolved) slot,
    ],
    resolved: [
      for (final entry in [
        ...fromYesterdayEntries,
        ...timeline,
        for (final slot in anyTime) TimelineEntry.task(slot),
      ])
        if (entry.isResolved) entry,
    ],
    asNeeded: [
      for (final medication in log.medications)
        if (medication.schedule is AsNeededSchedule)
          AsNeededItem(
            medication: medication,
            lastDose: log.lastDose(medication.id),
            stock: log.stockOf(medication.id),
          ),
    ],
    notes: log.notesWithin(notesHorizon, now: now),
    stock: {
      for (final medication in log.medications)
        if (log.stockOf(medication.id) case final StockLevel level)
          medication.id: level,
    },
    nextAppointment: log.appointments
        .where(
          (appointment) =>
              appointment.startsAt.isAfter(now) &&
              appointment.startsAt.difference(now) <= upcomingAppointmentWindow,
        )
        .firstOrNull,
    conflicts: [
      for (final conflict in log.conflicts.whereType<DoseConflict>())
        if (log.medication(conflict.medicationId) case final medication?)
          ConflictItem(
            conflict: conflict,
            medication: medication,
            slotAt: _sharedSlot(conflict),
          ),
    ],
  );
}

/// Whether [role] sees a summary of the day at the top of Today instead
/// of the next dose to give (`docs/roles.md`): admins, who coordinate
/// rather than record, and viewers, who cannot record.
bool showsDaySummary(MemberRole role) =>
    role == MemberRole.admin || role == MemberRole.viewer;

/// The first scheduled dose at or after [from], by time then name.
({Medication medication, DateTime at})? _firstDoseFrom(
  CareLog log,
  DateTime from,
) {
  ({Medication medication, DateTime at})? first;
  for (final medication in log.medications) {
    final at = medication.firstSlotFrom(from);
    if (at != null && (first == null || at.isBefore(first.at))) {
      first = (medication: medication, at: at);
    }
  }
  return first;
}

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// By time; at the same time doses first, then by name. Explicit all the
/// way down, since `List.sort` is not stable.
int _byTimeDosesFirst(TimelineEntry a, TimelineEntry b) {
  int kind(TimelineEntry entry) => entry is DoseEntry ? 0 : 1;
  String name(TimelineEntry entry) => switch (entry) {
    DoseEntry(:final slot) => slot.medication.details.name,
    TaskEntry(:final slot) => slot.task.details.name,
  };
  final byTime = a.slotAt.compareTo(b.slotAt);
  if (byTime != 0) return byTime;
  final byKind = kind(a) - kind(b);
  return byKind != 0 ? byKind : name(a).compareTo(name(b));
}

/// The scheduled time every dose in [conflict] was for, if they share one.
DateTime? _sharedSlot(DoseConflict conflict) {
  final slots = conflict.doses.map((dose) => dose.slotAt).toSet();
  return slots.length == 1 ? slots.single : null;
}

@riverpod
AsyncValue<TodayView> todayView(Ref ref) {
  final now = ref.watch(nowProvider);
  return ref.watch(careLogProvider).whenData((log) => buildTodayView(log, now));
}
