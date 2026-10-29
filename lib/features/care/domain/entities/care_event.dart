import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:i_care/features/care/domain/entities/appointment.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';

part 'care_event.freezed.dart';

/// Fields every event carries.
@freezed
abstract class EventMeta with _$EventMeta {
  const factory EventMeta({
    /// UUID generated on the device, so retries never duplicate an event.
    required String id,
    required String caregiverId,

    /// When it happened, by the device clock. Shown to people; never used
    /// to order or resolve anything, since device clocks drift.
    required DateTime occurredAt,

    /// When the server received it; null until synced. Orders the log.
    DateTime? receivedAt,
  }) = _EventMeta;

  const EventMeta._();

  bool get isSynced => receivedAt != null;
}

/// Why a dose was not given.
enum SkipReason { refused, asleep, unwell, doctorAdvice, other }

/// Something a caregiver did. The log of events is the source of truth;
/// everything shown is projected from it (see `docs/backend.md`).
///
/// Changes to an existing entity carry `baseVersion`: the version they
/// were made on. Two changes on the same version were made concurrently
/// and are flagged for review.
@freezed
sealed class CareEvent with _$CareEvent {
  const factory CareEvent.medicationCreated({
    required EventMeta meta,
    required String medicationId,
    required MedicationDetails details,
    required DoseSchedule schedule,
    required DateTime effectiveFrom,
  }) = MedicationCreated;

  const factory CareEvent.medicationUpdated({
    required EventMeta meta,
    required String medicationId,
    required int baseVersion,
    required MedicationDetails details,
  }) = MedicationUpdated;

  const factory CareEvent.scheduleChanged({
    required EventMeta meta,
    required String medicationId,
    required int baseVersion,
    required DoseSchedule schedule,
    required DateTime effectiveFrom,
  }) = ScheduleChanged;

  const factory CareEvent.medicationArchived({
    required EventMeta meta,
    required String medicationId,
    required int baseVersion,
  }) = MedicationArchived;

  const factory CareEvent.doseGiven({
    required EventMeta meta,
    required String medicationId,

    /// The scheduled time it covers; null for as-needed doses.
    required DateTime? slotAt,

    /// When the caregiver says it was given: now by default, earlier when
    /// they record it late. Spacing between doses is measured with it.
    required DateTime givenAt,

    /// Stored with the dose, so later edits never change past stock.
    required double units,

    /// Earlier doses a warning showed before this one was confirmed. A
    /// dose given knowing about another is not a conflict with it; with
    /// any other dose it still is.
    @Default(<String>[]) List<String> knownDoseIds,
    String? note,
  }) = DoseGiven;

  const factory CareEvent.doseSkipped({
    required EventMeta meta,
    required String medicationId,
    required DateTime slotAt,
    required SkipReason reason,
    String? note,
  }) = DoseSkipped;

  /// Cancels a [DoseGiven] or [DoseSkipped] recorded by mistake.
  const factory CareEvent.doseUndone({
    required EventMeta meta,
    required String targetEventId,
  }) = DoseUndone;

  /// Sets stock to a counted amount.
  const factory CareEvent.stockCounted({
    required EventMeta meta,
    required String medicationId,
    required double units,
  }) = StockCounted;

  /// Adds units to stock.
  const factory CareEvent.stockRefilled({
    required EventMeta meta,
    required String medicationId,
    required double units,
  }) = StockRefilled;

  const factory CareEvent.appointmentCreated({
    required EventMeta meta,
    required String appointmentId,
    required AppointmentDetails details,
  }) = AppointmentCreated;

  const factory CareEvent.appointmentUpdated({
    required EventMeta meta,
    required String appointmentId,
    required int baseVersion,
    required AppointmentDetails details,
  }) = AppointmentUpdated;

  const factory CareEvent.appointmentCancelled({
    required EventMeta meta,
    required String appointmentId,
    required int baseVersion,
  }) = AppointmentCancelled;

  /// What the doctor said, written by a caregiver after the visit.
  const factory CareEvent.visitNoteAdded({
    required EventMeta meta,
    required String appointmentId,
    required String text,
  }) = VisitNoteAdded;

  /// A caregiver reviewed a conflict; it stops being shown as pending.
  const factory CareEvent.conflictAcknowledged({
    required EventMeta meta,
    required String conflictKey,
  }) = ConflictAcknowledged;
}

/// Log order: synced events by server time, then this device's pending
/// events by device time (they will reach the server after everything it
/// already has). Ids break ties so every device sorts alike.
int compareEvents(CareEvent a, CareEvent b) {
  final (left, right) = (a.meta, b.meta);
  final byTime = switch ((left.receivedAt, right.receivedAt)) {
    (final DateTime x, final DateTime y) => x.compareTo(y),
    (DateTime(), null) => -1,
    (null, DateTime()) => 1,
    (null, null) => left.occurredAt.compareTo(right.occurredAt),
  };
  return byTime != 0 ? byTime : left.id.compareTo(right.id);
}
