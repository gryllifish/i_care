import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/domain/entities/appointment.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/care_task.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/features/care/domain/entities/recipient_profile.dart';

/// Builds events tersely. Ids are sequential so tests stay readable;
/// pass `receivedAt` to mark an event as synced.
class EventFactory {
  var _next = 0;

  /// A note left for the circle.
  CareNoteAdded careNote(
    String text, {
    required DateTime at,
    String by = 'ana',
  }) => CareEvent.careNoteAdded(
    meta: meta(at: at, by: by),
    text: text,
  ) as CareNoteAdded;

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
    ) as MedicationCreated;
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
    String? id,
  }) => CareEvent.doseGiven(
    meta: meta(at: at, by: by, receivedAt: receivedAt, id: id),
    medicationId: medicationId,
    slotAt: slotAt,
    givenAt: givenAt ?? at,
    units: units,
    knownDoseIds: [for (final dose in knowing) dose.meta.id],
  ) as DoseGiven;

  DoseSkipped skipped(
    String medicationId, {
    required DateTime at,
    required DateTime slotAt,
  }) => CareEvent.doseSkipped(
    meta: meta(at: at),
    medicationId: medicationId,
    slotAt: slotAt,
    reasonId: SkipReason.asleep.id,
  ) as DoseSkipped;

  DoseUndone undone(CareEvent target, {DateTime? at}) => CareEvent.doseUndone(
    meta: meta(at: at ?? target.meta.occurredAt),
    targetEventId: target.meta.id,
  ) as DoseUndone;

  StockCounted counted(String medicationId, double units, {DateTime? at}) =>
      CareEvent.stockCounted(
        meta: meta(at: at ?? DateTime(2026)),
        medicationId: medicationId,
        units: units,
      ) as StockCounted;

  StockRefilled refilled(String medicationId, double units, {DateTime? at}) =>
      CareEvent.stockRefilled(
        meta: meta(at: at ?? DateTime(2026)),
        medicationId: medicationId,
        units: units,
      ) as StockRefilled;

  MedicationUpdated updated(
    String medicationId, {
    required int baseVersion,
    String name = 'Enalapril',
    String by = 'ana',
    DateTime? at,
  }) => CareEvent.medicationUpdated(
    meta: meta(at: at ?? DateTime(2026), by: by),
    medicationId: medicationId,
    baseVersion: baseVersion,
    details: MedicationDetails(
      name: name,
      strength: '10 mg',
      form: MedicationForm.tablet,
    ),
  ) as MedicationUpdated;

  ScheduleChanged scheduleChanged(
    String medicationId, {
    required int baseVersion,
    required DoseSchedule schedule,
    required DateTime effectiveFrom,
  }) => CareEvent.scheduleChanged(
    meta: meta(at: effectiveFrom),
    medicationId: medicationId,
    baseVersion: baseVersion,
    schedule: schedule,
    effectiveFrom: effectiveFrom,
  ) as ScheduleChanged;

  MedicationArchived archived(
    String medicationId, {
    required int baseVersion,
  }) => CareEvent.medicationArchived(
    meta: meta(at: DateTime(2026)),
    medicationId: medicationId,
    baseVersion: baseVersion,
  ) as MedicationArchived;

  AppointmentCreated appointment(
    String appointmentId, {
    required DateTime startsAt,
    String title = 'Cardiology',
    DateTime? at,
  }) => CareEvent.appointmentCreated(
    meta: meta(at: at ?? DateTime(2026)),
    appointmentId: appointmentId,
    details: AppointmentDetails(title: title, startsAt: startsAt),
  ) as AppointmentCreated;

  AppointmentUpdated appointmentUpdated(
    String appointmentId, {
    required int baseVersion,
    required DateTime startsAt,
    String title = 'Cardiology',
    String by = 'ana',
    DateTime? at,
  }) => CareEvent.appointmentUpdated(
    meta: meta(at: at ?? DateTime(2026, 1, 2), by: by),
    appointmentId: appointmentId,
    baseVersion: baseVersion,
    details: AppointmentDetails(title: title, startsAt: startsAt),
  ) as AppointmentUpdated;

  AppointmentCancelled appointmentCancelled(
    String appointmentId, {
    required int baseVersion,
  }) => CareEvent.appointmentCancelled(
    meta: meta(at: DateTime(2026, 1, 2)),
    appointmentId: appointmentId,
    baseVersion: baseVersion,
  ) as AppointmentCancelled;

  VisitNoteAdded note(
    String appointmentId,
    String text, {
    String by = 'ana',
    DateTime? at,
  }) => CareEvent.visitNoteAdded(
    meta: meta(at: at ?? DateTime(2026, 1, 3), by: by),
    appointmentId: appointmentId,
    text: text,
  ) as VisitNoteAdded;

  DocumentLinked document(
    String appointmentId,
    String title, {
    String url = 'https://lab.example.com/results',
    String by = 'ana',
    DateTime? at,
  }) => CareEvent.documentLinked(
    meta: meta(at: at ?? DateTime(2026, 1, 3), by: by),
    appointmentId: appointmentId,
    title: title,
    url: url,
  ) as DocumentLinked;

  DocumentRemoved documentRemoved(DocumentLinked document, {DateTime? at}) =>
      CareEvent.documentRemoved(
        meta: meta(at: at ?? DateTime(2026, 1, 4)),
        appointmentId: document.appointmentId,
        documentId: document.meta.id,
      ) as DocumentRemoved;

  RecipientProfileUpdated profile(
    RecipientProfile profile, {
    int baseVersion = 0,
    String by = 'ana',
    DateTime? at,
  }) => CareEvent.recipientProfileUpdated(
    meta: meta(at: at ?? DateTime(2026), by: by),
    baseVersion: baseVersion,
    profile: profile,
  ) as RecipientProfileUpdated;

  TaskCreated task(
    String taskId, {
    String name = 'Bath',
    TaskSchedule schedule = const TaskSchedule(minutesOfDay: [10 * 60]),
    DateTime? at,
  }) => CareEvent.taskCreated(
    meta: meta(at: at ?? DateTime(2026)),
    taskId: taskId,
    details: TaskDetails(name: name),
    schedule: schedule,
  ) as TaskCreated;

  TaskUpdated taskUpdated(
    String taskId, {
    required int baseVersion,
    String name = 'Bath',
    TaskSchedule schedule = const TaskSchedule(minutesOfDay: [10 * 60]),
    String by = 'ana',
    DateTime? at,
  }) => CareEvent.taskUpdated(
    meta: meta(at: at ?? DateTime(2026, 1, 2), by: by),
    taskId: taskId,
    baseVersion: baseVersion,
    details: TaskDetails(name: name),
    schedule: schedule,
  ) as TaskUpdated;

  TaskArchived taskArchived(String taskId, {required int baseVersion}) =>
      CareEvent.taskArchived(
        meta: meta(at: DateTime(2026, 1, 2)),
        taskId: taskId,
        baseVersion: baseVersion,
      ) as TaskArchived;

  TaskDone taskDone(
    String taskId, {
    required DateTime slotAt,
    String by = 'ana',
    DateTime? at,
  }) => CareEvent.taskDone(
    meta: meta(at: at ?? slotAt, by: by),
    taskId: taskId,
    slotAt: slotAt,
  ) as TaskDone;

  TaskSkipped taskSkipped(
    String taskId, {
    required DateTime slotAt,
    SkipReason reason = SkipReason.refused,
    String? note,
    String by = 'ana',
  }) => CareEvent.taskSkipped(
    meta: meta(at: slotAt, by: by),
    taskId: taskId,
    slotAt: slotAt,
    reasonId: reason.id,
    note: note,
  ) as TaskSkipped;

  MemberInvited memberInvited(
    String memberId, {
    String name = 'Lucía',
    MemberRole role = MemberRole.helper,
    String by = 'ana',
    DateTime? at,
  }) => CareEvent.memberInvited(
    meta: meta(at: at ?? DateTime(2026), by: by),
    memberId: memberId,
    name: name,
    role: role,
    colorIndex: 0,
  ) as MemberInvited;

  MemberJoined memberJoined(String memberId, {DateTime? at}) =>
      CareEvent.memberJoined(
        meta: meta(at: at ?? DateTime(2026), by: systemAuthor),
        memberId: memberId,
      ) as MemberJoined;

  RoleChanged roleChanged(
    String memberId,
    MemberRole role, {
    required int baseVersion,
    String by = 'ana',
  }) => CareEvent.roleChanged(
    meta: meta(at: DateTime(2026, 1, 2), by: by),
    memberId: memberId,
    baseVersion: baseVersion,
    role: role,
  ) as RoleChanged;

  MemberRemoved memberRemoved(String memberId, {required int baseVersion}) =>
      CareEvent.memberRemoved(
        meta: meta(at: DateTime(2026, 1, 3)),
        memberId: memberId,
        baseVersion: baseVersion,
      ) as MemberRemoved;

  MemberLeft memberLeft(String memberId, {required String by}) =>
      CareEvent.memberLeft(
        meta: meta(at: DateTime(2026, 1, 4), by: by),
        memberId: memberId,
      ) as MemberLeft;

  ConflictAcknowledged acknowledged(String key) =>
      CareEvent.conflictAcknowledged(
        meta: meta(at: DateTime(2026)),
        conflictKey: key,
      ) as ConflictAcknowledged;
}

extension WithAuthor<T extends CareEvent> on T {
  /// This event as written by [memberId].
  T withAuthor(String memberId) =>
      copyWith(meta: meta.copyWith(caregiverId: memberId)) as T;
}

/// The server's time [at], or a moment after: the server keeps each
/// `receivedAt` later than the one before, so events received in the same
/// instant still sort in the order they arrived.
Matcher receivedAround(DateTime at) => isA<DateTime>().having(
  (received) => received.difference(at),
  'after $at by',
  allOf(greaterThanOrEqualTo(Duration.zero), lessThan(_instant)),
);

const _instant = Duration(milliseconds: 1);
