import 'package:i_care/features/care/domain/entities/appointment.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';

/// Builds events tersely. Ids are sequential so tests stay readable;
/// pass `receivedAt` to mark an event as synced.
class EventFactory {
  var _next = 0;

  EventMeta meta({
    required DateTime at,
    String by = 'ana',
    DateTime? receivedAt,
    String? id,
  }) => EventMeta(
    id: id ?? 'e${(_next++).toString().padLeft(3, '0')}',
    caregiverId: by,
    occurredAt: at,
    receivedAt: receivedAt,
  );

  MedicationCreated created(
    String medicationId, {
    DoseSchedule schedule = const DoseSchedule.fixed(
      minutesOfDay: [8 * 60, 20 * 60],
    ),
    DateTime? effectiveFrom,
    String name = 'Enalapril',
    double unitsPerDose = 1,
    int lowStockDays = 7,
    DateTime? at,
  }) {
    final start = effectiveFrom ?? DateTime(2026);
    return CareEvent.medicationCreated(
          meta: meta(at: at ?? start),
          medicationId: medicationId,
          details: MedicationDetails(
            name: name,
            strength: '10 mg',
            form: MedicationForm.tablet,
            unitsPerDose: unitsPerDose,
            lowStockDays: lowStockDays,
          ),
          schedule: schedule,
          effectiveFrom: start,
        )
        as MedicationCreated;
  }

  DoseGiven given(
    String medicationId, {
    required DateTime at,
    DateTime? slotAt,
    DateTime? givenAt,
    String by = 'ana',
    double units = 1,
    List<DoseGiven> knowing = const [],
    DateTime? receivedAt,
  }) =>
      CareEvent.doseGiven(
            meta: meta(at: at, by: by, receivedAt: receivedAt),
            medicationId: medicationId,
            slotAt: slotAt,
            givenAt: givenAt ?? at,
            units: units,
            knownDoseIds: [for (final dose in knowing) dose.meta.id],
          )
          as DoseGiven;

  DoseSkipped skipped(
    String medicationId, {
    required DateTime at,
    required DateTime slotAt,
  }) =>
      CareEvent.doseSkipped(
            meta: meta(at: at),
            medicationId: medicationId,
            slotAt: slotAt,
            reason: SkipReason.asleep,
          )
          as DoseSkipped;

  DoseUndone undone(CareEvent target, {DateTime? at}) =>
      CareEvent.doseUndone(
            meta: meta(at: at ?? target.meta.occurredAt),
            targetEventId: target.meta.id,
          )
          as DoseUndone;

  StockCounted counted(String medicationId, double units, {DateTime? at}) =>
      CareEvent.stockCounted(
            meta: meta(at: at ?? DateTime(2026)),
            medicationId: medicationId,
            units: units,
          )
          as StockCounted;

  StockRefilled refilled(String medicationId, double units, {DateTime? at}) =>
      CareEvent.stockRefilled(
            meta: meta(at: at ?? DateTime(2026)),
            medicationId: medicationId,
            units: units,
          )
          as StockRefilled;

  MedicationUpdated updated(
    String medicationId, {
    required int baseVersion,
    String name = 'Enalapril',
    String by = 'ana',
    DateTime? at,
  }) =>
      CareEvent.medicationUpdated(
            meta: meta(at: at ?? DateTime(2026), by: by),
            medicationId: medicationId,
            baseVersion: baseVersion,
            details: MedicationDetails(
              name: name,
              strength: '10 mg',
              form: MedicationForm.tablet,
            ),
          )
          as MedicationUpdated;

  ScheduleChanged scheduleChanged(
    String medicationId, {
    required int baseVersion,
    required DoseSchedule schedule,
    required DateTime effectiveFrom,
  }) =>
      CareEvent.scheduleChanged(
            meta: meta(at: effectiveFrom),
            medicationId: medicationId,
            baseVersion: baseVersion,
            schedule: schedule,
            effectiveFrom: effectiveFrom,
          )
          as ScheduleChanged;

  MedicationArchived archived(
    String medicationId, {
    required int baseVersion,
  }) =>
      CareEvent.medicationArchived(
            meta: meta(at: DateTime(2026)),
            medicationId: medicationId,
            baseVersion: baseVersion,
          )
          as MedicationArchived;

  AppointmentCreated appointment(
    String appointmentId, {
    required DateTime startsAt,
    String title = 'Cardiology',
    DateTime? at,
  }) =>
      CareEvent.appointmentCreated(
            meta: meta(at: at ?? DateTime(2026)),
            appointmentId: appointmentId,
            details: AppointmentDetails(title: title, startsAt: startsAt),
          )
          as AppointmentCreated;

  AppointmentUpdated appointmentUpdated(
    String appointmentId, {
    required int baseVersion,
    required DateTime startsAt,
    String title = 'Cardiology',
    String by = 'ana',
    DateTime? at,
  }) =>
      CareEvent.appointmentUpdated(
            meta: meta(at: at ?? DateTime(2026, 1, 2), by: by),
            appointmentId: appointmentId,
            baseVersion: baseVersion,
            details: AppointmentDetails(title: title, startsAt: startsAt),
          )
          as AppointmentUpdated;

  AppointmentCancelled appointmentCancelled(
    String appointmentId, {
    required int baseVersion,
  }) =>
      CareEvent.appointmentCancelled(
            meta: meta(at: DateTime(2026, 1, 2)),
            appointmentId: appointmentId,
            baseVersion: baseVersion,
          )
          as AppointmentCancelled;

  VisitNoteAdded note(
    String appointmentId,
    String text, {
    String by = 'ana',
    DateTime? at,
  }) =>
      CareEvent.visitNoteAdded(
            meta: meta(at: at ?? DateTime(2026, 1, 3), by: by),
            appointmentId: appointmentId,
            text: text,
          )
          as VisitNoteAdded;

  ConflictAcknowledged acknowledged(String key) =>
      CareEvent.conflictAcknowledged(
            meta: meta(at: DateTime(2026)),
            conflictKey: key,
          )
          as ConflictAcknowledged;
}
