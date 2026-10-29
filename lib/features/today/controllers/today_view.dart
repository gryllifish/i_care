import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/conflict.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/entities/dose_slot.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';
import 'package:i_care/features/care/domain/entities/stock_level.dart';
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

    /// Today's doses by part of the day, in day order; empty parts left
    /// out.
    @Default(<DayPart, List<DoseSlot>>{})
    Map<DayPart, List<DoseSlot>> byDayPart,
    @Default(<AsNeededItem>[]) List<AsNeededItem> asNeeded,

    /// Stock per medication, for low-stock badges.
    @Default(<String, StockLevel>{}) Map<String, StockLevel> stock,

    /// Dose conflicts nobody has reviewed. Edit conflicts are shown with
    /// the medication they affect.
    @Default(<ConflictItem>[]) List<ConflictItem> conflicts,
  }) = _TodayView;
}

/// Builds the Today screen's state from the log at [now].
TodayView buildTodayView(CareLog log, DateTime now) {
  final day = DateTime(now.year, now.month, now.day);
  final slots = log.slotsOn(day, now: now);
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
        if (slots.where((slot) => slot.dayPart == part).toList()
            case final List<DoseSlot> inPart when inPart.isNotEmpty)
          part: inPart,
    },
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
