import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';

part 'dose_slot.freezed.dart';

enum DoseStatus {
  /// More than [DoseTiming.window] ahead.
  upcoming,

  /// Within [DoseTiming.window] of its time.
  due,

  /// More than [DoseTiming.window] late and not resolved.
  overdue,
  given,
  skipped,
}

abstract final class DoseTiming {
  /// How early or late a dose still counts as on time.
  static const window = Duration(minutes: 30);
}

/// Part of the day a dose belongs to, for grouping.
enum DayPart {
  morning,
  midday,
  afternoon,
  night;

  static const _middayFromHour = 12;
  static const _afternoonFromHour = 15;
  static const _nightFromHour = 20;
  static const _morningFromHour = 5;

  static DayPart of(DateTime time) => switch (time.hour) {
    < _morningFromHour => night,
    < _middayFromHour => morning,
    < _afternoonFromHour => midday,
    < _nightFromHour => afternoon,
    _ => night,
  };
}

/// One scheduled dose and what caregivers recorded for it.
@freezed
abstract class DoseSlot with _$DoseSlot {
  const factory DoseSlot({
    required Medication medication,
    required DateTime slotAt,
    required DoseStatus status,

    /// Doses recorded as given, in log order. More than one is a conflict
    /// unless each later one was given knowing about the others.
    @Default(<DoseGiven>[]) List<DoseGiven> given,
    @Default(<DoseSkipped>[]) List<DoseSkipped> skipped,

    /// An unreviewed conflict involves this dose.
    @Default(false) bool hasConflict,
  }) = _DoseSlot;

  const DoseSlot._();

  DayPart get dayPart => DayPart.of(slotAt);

  /// Given more than once, knowingly or not; shown even without a
  /// conflict, since the patient did get both doses.
  bool get isDouble => given.length > 1;

  /// Whether [caregiverId] already recorded it as given: they would fix
  /// that record rather than give it again.
  bool isGivenBy(String caregiverId) =>
      given.any((dose) => dose.meta.caregiverId == caregiverId);
}
