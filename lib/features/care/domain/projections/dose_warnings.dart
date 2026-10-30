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
  const AlreadyGiven(this.doses);

  /// Every record of it, in log order: confirming anyway knows them all.
  final List<DoseGiven> doses;
}

/// Another dose is closer than the entered minimum interval: usually the
/// last one, or a later one when recording a dose given earlier.
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

/// This device is offline right now, so others' doses may be missing
/// from what it shows, however recently it synced.
final class Offline extends DoseWarning {
  const Offline();
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
      AlreadyGiven(:final doses) => [for (final dose in doses) dose.meta.id],
      TooSoon(:final lastDose) => [lastDose.meta.id],
      DailyLimitReached() || Offline() || OutOfDate() => const <String>[],
    },
];

/// How long without syncing before [OutOfDate] is raised.
const staleSyncAfter = Duration(minutes: 10);

/// What to warn about before recording [medication] as given at
/// [givenAt] (default [now]), for the scheduled dose at [slotAt] (null for
/// as-needed doses).
List<DoseWarning> doseWarnings(
  CareLog log, {
  required Medication medication,
  required DateTime? slotAt,
  required DateTime now,
  required DateTime? lastSyncedAt,
  required bool isConnected,
  DateTime? givenAt,
}) {
  final at = givenAt ?? now;
  final schedule = medication.scheduleAt(at) ?? medication.schedule;
  final alreadyGiven = slotAt == null
      ? const <DoseGiven>[]
      : log.givenFor(medication.id, slotAt);
  final minInterval = switch (schedule) {
    FixedSchedule(:final minInterval) => minInterval,
    AsNeededSchedule(:final minInterval) => minInterval,
  };
  final maxPerDay = switch (schedule) {
    AsNeededSchedule(:final maxPerDay) => maxPerDay,
    FixedSchedule() => null,
  };
  final givenThatDay = log.givenOn(medication.id, at).length;
  final closest = minInterval == null
      ? null
      : _closestWithin(log.dosesGiven(medication.id), at, minInterval);

  return [
    if (alreadyGiven.isNotEmpty) AlreadyGiven(alreadyGiven),
    if ((minInterval, closest) case (
      final Duration interval,
      final DoseGiven other,
    ))
      TooSoon(lastDose: other, allowedFrom: other.givenAt.add(interval)),
    if (maxPerDay != null && givenThatDay >= maxPerDay)
      DailyLimitReached(given: givenThatDay, max: maxPerDay),
    if (!isConnected)
      const Offline()
    else if (lastSyncedAt == null ||
        now.difference(lastSyncedAt) > staleSyncAfter)
      OutOfDate(lastSyncedAt: lastSyncedAt),
  ];
}

/// The dose nearest to [at] if it is closer than [interval].
DoseGiven? _closestWithin(
  List<DoseGiven> doses,
  DateTime at,
  Duration interval,
) {
  DoseGiven? closest;
  Duration? distance;
  for (final dose in doses) {
    final gap = dose.givenAt.difference(at).abs();
    if (gap < interval && (distance == null || gap < distance)) {
      closest = dose;
      distance = gap;
    }
  }
  return closest;
}
