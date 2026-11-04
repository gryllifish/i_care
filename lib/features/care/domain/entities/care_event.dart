import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:i_care/features/care/domain/entities/appointment.dart';
import 'package:i_care/features/care/domain/entities/care_task.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/features/care/domain/entities/recipient_profile.dart';

part 'care_event.freezed.dart';

/// Fields every event carries.
@freezed
abstract class EventMeta with _$EventMeta {
  const factory EventMeta({
    /// UUID generated on the device, so retries never duplicate an event.
    required String id,

    /// The member who wrote it, or [systemAuthor] for events the server
    /// writes. The name predates roles; the wire format keeps it.
    required String caregiverId,

    /// When it happened, by the device clock. Shown to people; never used
    /// to order or resolve anything, since device clocks drift.
    required DateTime occurredAt,

    /// When the server received it; null until synced. Shown to people.
    DateTime? receivedAt,

    /// The server's position for it in the log, set with [receivedAt].
    /// Orders the log: timestamps cannot, since the web keeps only
    /// milliseconds and events of one push may share one. Null on copies
    /// synced before servers numbered events.
    int? serverSeq,

    /// Set by the server on a fact (a dose or task record) from a device
    /// whose member had left the circle by the time it synced: accepted,
    /// since it may be true, and flagged for admins (`docs/roles.md`).
    @Default(false) bool fromFormerMember,
  }) = _EventMeta;

  const EventMeta._();

  bool get isSynced => receivedAt != null;
}

/// Author of the events the server writes itself, such as a device
/// joining with a code.
const systemAuthor = 'system';

/// The standard reasons why a dose was not given or a task not done,
/// translated on every phone. A circle can hide them and add its own
/// (`SkipReasonAdded`); events store a reason by id, these by their
/// [id] and the circle's by theirs.
enum SkipReason {
  refused('refused'),
  asleep('asleep'),
  unwell('unwell'),

  /// Medications only.
  doctorAdvice('doctor_advice'),

  /// Always offered, with room to say what happened.
  other('other');

  SkipReason(this.id);

  /// As stored in events.
  final String id;

  static SkipReason? byId(String id) {
    for (final reason in values) {
      if (reason.id == id) return reason;
    }
    return null;
  }
}

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

    /// A [SkipReason]'s id, or one of the circle's own.
    required String reasonId,

    /// What happened, in the caregiver's words; mostly with "Other".
    String? note,
  }) = DoseSkipped;

  /// Cancels a [DoseGiven], [DoseSkipped], [TaskDone] or [TaskSkipped]
  /// recorded by mistake. Its name predates tasks; the wire format keeps
  /// it.
  const factory CareEvent.doseUndone({
    required EventMeta meta,
    required String targetEventId,

    /// The conflict being reviewed when this cancels a repeated record
    /// ("No, only one"); null when someone takes back a mistake.
    String? conflictKey,
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

  /// Something to tell the rest of the circle ("te dejo dicho"): how the
  /// day went, what to watch for. Notes are never edited or removed; a
  /// later one says what changed.
  const factory CareEvent.careNoteAdded({
    required EventMeta meta,
    required String text,
  }) = CareNoteAdded;

  /// A link to a study, result or report, kept with an appointment. Files
  /// are not stored: the link points to wherever they already live (a
  /// lab's portal, a shared folder).
  const factory CareEvent.documentLinked({
    required EventMeta meta,
    required String appointmentId,
    required String title,

    /// An http or https URL.
    required String url,
  }) = DocumentLinked;

  /// Takes a [DocumentLinked] off its appointment; Activity keeps both.
  const factory CareEvent.documentRemoved({
    required EventMeta meta,
    required String appointmentId,

    /// The id of the [DocumentLinked] event.
    required String documentId,
  }) = DocumentRemoved;

  /// Replaces the emergency card's profile of the person cared for.
  const factory CareEvent.recipientProfileUpdated({
    required EventMeta meta,
    required int baseVersion,
    required RecipientProfile profile,
  }) = RecipientProfileUpdated;

  const factory CareEvent.taskCreated({
    required EventMeta meta,
    required String taskId,
    required TaskDetails details,
    required TaskSchedule schedule,
  }) = TaskCreated;

  /// Replaces a task's details and schedule. Unlike a medication's, a
  /// task's schedule has no history: past records keep their own times.
  const factory CareEvent.taskUpdated({
    required EventMeta meta,
    required String taskId,
    required int baseVersion,
    required TaskDetails details,
    required TaskSchedule schedule,
  }) = TaskUpdated;

  const factory CareEvent.taskArchived({
    required EventMeta meta,
    required String taskId,
    required int baseVersion,
  }) = TaskArchived;

  const factory CareEvent.taskDone({
    required EventMeta meta,
    required String taskId,

    /// The time it was due; the start of the day for a task with no set
    /// time.
    required DateTime slotAt,
  }) = TaskDone;

  const factory CareEvent.taskSkipped({
    required EventMeta meta,
    required String taskId,
    required DateTime slotAt,

    /// A [SkipReason]'s id, or one of the circle's own.
    required String reasonId,
    String? note,
  }) = TaskSkipped;

  /// The circle began: written by the server ([systemAuthor]) when
  /// someone creates it, before its first member.
  const factory CareEvent.circleCreated({
    required EventMeta meta,

    /// How the app names the person cared for ("Caring for Elena").
    required String recipientName,

    /// The demo's sample circle, labeled as such in the app.
    @Default(false) bool isSample,
  }) = CircleCreated;

  /// A reason of the circle's own, offered next to the standard ones.
  const factory CareEvent.skipReasonAdded({
    required EventMeta meta,
    required String reasonId,
    required String label,
  }) = SkipReasonAdded;

  /// Stops offering a reason, standard or the circle's; records that used
  /// it keep it.
  const factory CareEvent.skipReasonHidden({
    required EventMeta meta,
    required String reasonId,
  }) = SkipReasonHidden;

  /// Offers a hidden reason again.
  const factory CareEvent.skipReasonShown({
    required EventMeta meta,
    required String reasonId,
  }) = SkipReasonShown;

  /// An admin invites someone; they show as invited until a device joins
  /// as them.
  const factory CareEvent.memberInvited({
    required EventMeta meta,
    required String memberId,
    required String name,
    required MemberRole role,
    required int colorIndex,
  }) = MemberInvited;

  /// An admin withdraws an invitation nobody has used.
  const factory CareEvent.invitationRevoked({
    required EventMeta meta,
    required String memberId,
  }) = InvitationRevoked;

  /// Written by the server ([systemAuthor]) when a device joins as
  /// [memberId] with a code.
  const factory CareEvent.memberJoined({
    required EventMeta meta,
    required String memberId,
  }) = MemberJoined;

  /// Written by the server ([systemAuthor]) when [memberId] signs in on
  /// another phone with their protected access (`docs/roles.md`,
  /// recoverable access).
  const factory CareEvent.accessRecovered({
    required EventMeta meta,
    required String memberId,
  }) = AccessRecovered;

  const factory CareEvent.roleChanged({
    required EventMeta meta,
    required String memberId,
    required int baseVersion,
    required MemberRole role,
  }) = RoleChanged;

  const factory CareEvent.memberRemoved({
    required EventMeta meta,
    required String memberId,
    required int baseVersion,
  }) = MemberRemoved;

  /// One of [memberId]'s devices left the circle by itself.
  const factory CareEvent.memberLeft({
    required EventMeta meta,
    required String memberId,
  }) = MemberLeft;

  /// A caregiver reviewed a conflict; it stops being shown as pending.
  const factory CareEvent.conflictAcknowledged({
    required EventMeta meta,
    required String conflictKey,
  }) = ConflictAcknowledged;
}

/// Log order: synced events by their place on the server, then this
/// device's pending events by device time (they will reach the server
/// after everything it already has). Copies synced before servers
/// numbered events come first, by server time: everything numbered was
/// received after them. Ids break ties so every device sorts alike.
int compareEvents(CareEvent a, CareEvent b) {
  final (left, right) = (a.meta, b.meta);
  final byGroup = _orderGroup(left).compareTo(_orderGroup(right));
  if (byGroup != 0) return byGroup;
  final byPlace = switch ((left.serverSeq, right.serverSeq)) {
    (final int x, final int y) => x.compareTo(y),
    _ => switch ((left.receivedAt, right.receivedAt)) {
      (final DateTime x, final DateTime y) => x.compareTo(y),
      _ => left.occurredAt.compareTo(right.occurredAt),
    },
  };
  return byPlace != 0 ? byPlace : left.id.compareTo(right.id);
}

/// Synced before numbering, numbered, pending.
int _orderGroup(EventMeta meta) => switch (meta) {
  EventMeta(isSynced: false) => 2,
  EventMeta(serverSeq: null) => 0,
  _ => 1,
};
