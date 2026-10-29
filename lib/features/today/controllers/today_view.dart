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

/// Everything the Today screen shows.
@freezed
abstract class TodayView with _$TodayView {
  const factory TodayView({
    required DateTime day,

    /// The dose to attend to first: the earliest due or late one, else
    /// the next upcoming one; null when the day is done.
    DoseSlot? next,

    /// Yesterday's doses nobody resolved.
    @Default(<DoseSlot>[]) List<DoseSlot> fromYesterday,

    /// Today's doses by part of the day, in day order; empty parts left
    /// out.
    @Default(<DayPart, List<DoseSlot>>{})
    Map<DayPart, List<DoseSlot>> byDayPart,
    @Default(<AsNeededItem>[]) List<AsNeededItem> asNeeded,

    /// Stock per medication, for low-stock badges.
    @Default(<String, StockLevel>{}) Map<String, StockLevel> stock,
    @Default(<Conflict>[]) List<Conflict> conflicts,
  }) = _TodayView;
}

/// Builds the Today screen's state from the log at [now].
TodayView buildTodayView(CareLog log, DateTime now) {
  final day = DateTime(now.year, now.month, now.day);
  final slots = log.slotsOn(day, now: now);
  final fromYesterday = log.unresolvedBefore(day, now: now);
  final pending = [
    ...fromYesterday,
    ...slots.where(
      (slot) =>
          slot.status == DoseStatus.due || slot.status == DoseStatus.overdue,
    ),
  ];

  return TodayView(
    day: day,
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
    conflicts: log.conflicts,
  );
}

@riverpod
AsyncValue<TodayView> todayView(Ref ref) {
  final now = ref.watch(nowProvider);
  return ref.watch(careLogProvider).whenData((log) => buildTodayView(log, now));
}
