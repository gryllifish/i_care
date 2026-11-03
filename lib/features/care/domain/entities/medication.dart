import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';

part 'medication.freezed.dart';

enum MedicationForm {
  tablet,
  capsule,
  liquid,
  drops,
  injection,
  patch,
  inhaler,
  other,
}

/// What caregivers enter about a medication, apart from its schedule.
@freezed
abstract class MedicationDetails with _$MedicationDetails {
  const factory MedicationDetails({
    required String name,

    /// Free text as written on the box, e.g. "500 mg".
    required String strength,
    required MedicationForm form,

    /// Free text from the prescription, e.g. "With food".
    @Default('') String instructions,

    /// Units taken per dose; fractional for half tablets.
    @Default(1) double unitsPerDose,

    /// Stock counts as low when it lasts this many days or fewer.
    @Default(7) int lowStockDays,
  }) = _MedicationDetails;
}

/// A medication as projected from the event log.
@freezed
abstract class Medication with _$Medication {
  const factory Medication({
    required String id,
    required MedicationDetails details,

    /// Ascending by `effectiveFrom`; never empty.
    required List<ScheduleVersion> schedules,
    @Default(false) bool isArchived,

    /// Number of changes applied. Edits carry the version they started
    /// from, so concurrent edits can be detected.
    @Default(0) int version,
  }) = _Medication;

  const Medication._();

  /// The schedule in effect now: the latest version.
  DoseSchedule get schedule => schedules.last.schedule;

  /// The schedule in effect at [moment], or null before the first one.
  DoseSchedule? scheduleAt(DateTime moment) {
    for (final version in schedules.reversed) {
      if (!version.effectiveFrom.isAfter(moment)) return version.schedule;
    }
    return null;
  }

  /// Scheduled times on [day], each taken from the schedule version in
  /// effect at that time.
  List<DateTime> slotsOn(DateTime day) => [
    for (final (index, version) in schedules.indexed)
      for (final slot in version.schedule.slotsOn(day))
        if (!slot.isBefore(version.effectiveFrom) &&
            (index == schedules.length - 1 ||
                slot.isBefore(schedules[index + 1].effectiveFrom)))
          slot,
  ];

  /// The first scheduled time at or after [from] within a week, from the
  /// schedule version in effect then; null when as needed.
  DateTime? firstSlotFrom(DateTime from) => firstScheduledFrom(from, slotsOn);
}
