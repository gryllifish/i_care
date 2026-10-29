import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/projections/care_log.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'activity_view.freezed.dart';
part 'activity_view.g.dart';

/// One thing a caregiver did, with the medication it concerns.
@freezed
abstract class ActivityEntry with _$ActivityEntry {
  const factory ActivityEntry({
    required CareEvent event,

    /// Name of the medication involved, looked up through the cancelled
    /// record for undos; null when none applies or it is unknown.
    String? medicationName,
  }) = _ActivityEntry;
}

/// A day's entries, newest first.
typedef ActivityDay = ({DateTime day, List<ActivityEntry> entries});

/// The log as a feed, newest first, grouped by day. Ordered by when
/// things happened, as people remember them; the log's own order (by
/// server time) still decides everything else.
List<ActivityDay> buildActivity(CareLog log) {
  final byId = {for (final event in log.events) event.meta.id: event};
  String? nameOf(String medicationId) =>
      log.medication(medicationId)?.details.name;
  String? medicationOf(CareEvent event) => switch (event) {
    MedicationCreated(:final medicationId) ||
    MedicationUpdated(:final medicationId) ||
    ScheduleChanged(:final medicationId) ||
    MedicationArchived(:final medicationId) ||
    DoseGiven(:final medicationId) ||
    DoseSkipped(:final medicationId) ||
    StockCounted(:final medicationId) ||
    StockRefilled(:final medicationId) => nameOf(medicationId),
    DoseUndone(:final targetEventId) => switch (byId[targetEventId]) {
      final CareEvent target => medicationOf(target),
      null => null,
    },
    ConflictAcknowledged() => null,
  };

  final newestFirst = [...log.events]
    ..sort((a, b) => b.meta.occurredAt.compareTo(a.meta.occurredAt));
  final days = <ActivityDay>[];
  for (final event in newestFirst) {
    final at = event.meta.occurredAt;
    final day = DateTime(at.year, at.month, at.day);
    if (days.isEmpty || days.last.day != day) {
      days.add((day: day, entries: []));
    }
    days.last.entries.add(
      ActivityEntry(event: event, medicationName: medicationOf(event)),
    );
  }
  return days;
}

@riverpod
AsyncValue<List<ActivityDay>> activityView(Ref ref) =>
    ref.watch(careLogProvider).whenData(buildActivity);
