import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';
import 'package:i_care/features/care/domain/projections/care_log.dart';

/// A reason to stop and confirm before recording a dose as given. Every
/// rule uses values a caregiver entered; none is medical advice.
sealed class DoseWarning {
  const DoseWarning();
}

/// Someone already recorded this scheduled dose.
final class AlreadyGiven extends DoseWarning {
  const AlreadyGiven(this.dose);

  final DoseGiven dose;
}

/// The last dose was less than the entered minimum interval ago.
final class TooSoon extends DoseWarning {
  const TooSoon({required this.lastDose, required this.allowedFrom});

  final DoseGiven lastDose;
  final DateTime allowedFrom;
}

/// The entered maximum per day was already given today.
final class DailyLimitReached extends DoseWarning {
  const DailyLimitReached({required this.given, required this.max});

  final int given;
  final int max;
}

/// This device has not synced for a while, so others' doses may be
/// missing from what it shows.
final class OutOfDate extends DoseWarning {
  const OutOfDate({this.lastSyncedAt});

  /// Null when it never synced.
  final DateTime? lastSyncedAt;
}

/// Ids of the doses [warnings] showed, for `DoseGiven.knownDoseIds` when
/// the caregiver confirms anyway.
List<String> knownDoseIdsOf(List<DoseWarning> warnings) => [
  for (final warning in warnings)
    ...switch (warning) {
      AlreadyGiven(:final dose) => [dose.meta.id],
      TooSoon(:final lastDose) => [lastDose.meta.id],
      DailyLimitReached() || OutOfDate() => const <String>[],
    },
];

/// How long without syncing before [OutOfDate] is raised.
const staleSyncAfter = Duration(minutes: 10);

/// What to warn about before giving [medication] at [now], for the
/// scheduled dose at [slotAt] (null for as-needed doses).
List<DoseWarning> doseWarnings(
  CareLog log, {
  required Medication medication,
  required DateTime? slotAt,
  required DateTime now,
  required DateTime? lastSyncedAt,
}) {
  final schedule = medication.scheduleAt(now) ?? medication.schedule;
  final lastDose = log.lastDose(medication.id);
  final alreadyGiven = slotAt == null
      ? null
      : log.givenFor(medication.id, slotAt).firstOrNull;
  final minInterval = switch (schedule) {
    FixedSchedule(:final minInterval) => minInterval,
    AsNeededSchedule(:final minInterval) => minInterval,
  };
  final maxPerDay = switch (schedule) {
    AsNeededSchedule(:final maxPerDay) => maxPerDay,
    FixedSchedule() => null,
  };
  final givenToday = log.givenOn(medication.id, now).length;

  return [
    if (alreadyGiven != null) AlreadyGiven(alreadyGiven),
    if ((minInterval, lastDose) case (
      final Duration interval,
      final DoseGiven last,
    ) when now.isBefore(last.givenAt.add(interval)))
      TooSoon(
        lastDose: last,
        allowedFrom: last.givenAt.add(interval),
      ),
    if (maxPerDay != null && givenToday >= maxPerDay)
      DailyLimitReached(given: givenToday, max: maxPerDay),
    if (lastSyncedAt == null || now.difference(lastSyncedAt) > staleSyncAfter)
      OutOfDate(lastSyncedAt: lastSyncedAt),
  ];
}
