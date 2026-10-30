import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/domain/entities/appointment.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/conflict.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/entities/dose_slot.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';
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

  DayPart get dayPart => DayPart.of(slotAt);
}

/// Everything the Today screen shows.
@freezed
abstract class TodayView with _$TodayView {
  const factory TodayView({
    required DateTime day,

    /// Today's scheduled doses, and how many are given or skipped.
    @Default(0) int totalToday,
    @Default(0) int resolvedToday,

    /// The dose to attend to first: the earliest due or late one, else
    /// the next upcoming one; null when the day is done.
    DoseSlot? next,

    /// Yesterday's doses still unresolved, or resolved today.
    @Default(<DoseSlot>[]) List<DoseSlot> fromYesterday,

    /// Today's doses and timed tasks by part of the day, in day order;
    /// empty parts left out. At the same time, doses come first.
    @Default(<DayPart, List<TimelineEntry>>{})
    Map<DayPart, List<TimelineEntry>> byDayPart,

    /// Today's tasks with no set time.
    @Default(<TaskSlot>[]) List<TaskSlot> anyTimeTasks,
    @Default(<AsNeededItem>[]) List<AsNeededItem> asNeeded,

    /// The next appointment if it is within [upcomingAppointmentWindow].
    Appointment? nextAppointment,

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
  final pending = [
    ...[...fromYesterday, ...slots].where(
      (slot) =>
          slot.status == DoseStatus.due || slot.status == DoseStatus.overdue,
    ),
  ];

  return TodayView(
    day: day,
    totalToday: slots.length,
    resolvedToday: slots
        .where(
          (slot) =>
              slot.status == DoseStatus.given ||
              slot.status == DoseStatus.skipped,
        )
        .length,
    next:
        pending.firstOrNull ??
        slots.where((slot) => slot.status == DoseStatus.upcoming).firstOrNull,
    fromYesterday: fromYesterday,
    byDayPart: {
      for (final part in DayPart.values)
        if (timeline.where((entry) => entry.dayPart == part).toList()
            case final List<TimelineEntry> inPart when inPart.isNotEmpty)
          part: inPart,
    },
    anyTimeTasks: [
      for (final slot in tasks)
        if (slot.isAnyTime) slot,
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
