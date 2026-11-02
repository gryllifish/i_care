import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/utils/formatters.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/shared/l10n/care_labels.dart';

/// What [event] says in one sentence, as Activity lists it: "Ana gave
/// the 08:00 Enalapril". [author] is who wrote it; [subject] the name of
/// what it is about (`CareLog.subjectOf`), when known.
String eventSentence(
  AppLocalizations l10n, {
  required CareEvent event,
  required String author,
  required String? subject,
  required String locale,
}) {
  final name = author;
  final medication = subject ?? l10n.unknownMedication;
  final appointment = subject ?? l10n.unknownAppointment;
  final task = subject ?? l10n.unknownTask;
  final member = subject ?? l10n.unknownCaregiver;
  String time(DateTime at) => Formatters.time(at, locale);
  String units(double value) => Formatters.units(value, locale);

  return switch (event) {
    MedicationCreated() => l10n.activityCreated(name, medication),
    MedicationUpdated() => l10n.activityUpdated(name, medication),
    ScheduleChanged() => l10n.activityScheduleChanged(name, medication),
    MedicationArchived() => l10n.activityArchived(name, medication),
    DoseGiven(:final DateTime slotAt) => l10n.activityGivenSlot(
      name,
      medication,
      time(slotAt),
    ),
    DoseGiven() => l10n.activityGiven(name, medication),
    DoseSkipped(:final slotAt, :final reason) => l10n.activitySkipped(
      name,
      medication,
      time(slotAt),
      reason.label(l10n),
    ),
    DoseUndone() => l10n.activityUndone(name, medication),
    StockCounted(units: final count) => l10n.activityCounted(
      name,
      medication,
      units(count),
    ),
    StockRefilled(units: final count) => l10n.activityRefilled(
      name,
      units(count),
      medication,
    ),
    AppointmentCreated() => l10n.activityAppointmentCreated(
      name,
      appointment,
    ),
    AppointmentUpdated() => l10n.activityAppointmentUpdated(
      name,
      appointment,
    ),
    AppointmentCancelled() => l10n.activityAppointmentCancelled(
      name,
      appointment,
    ),
    VisitNoteAdded() => l10n.activityVisitNote(name, appointment),
    DocumentLinked(title: final document) => l10n.activityDocumentLinked(
      name,
      document,
      appointment,
    ),
    DocumentRemoved() => l10n.activityDocumentRemoved(name, appointment),
    TaskCreated() => l10n.activityTaskCreated(name, task),
    TaskUpdated() => l10n.activityTaskUpdated(name, task),
    TaskArchived() => l10n.activityTaskArchived(name, task),
    TaskDone() => l10n.activityTaskDone(name, task),
    TaskSkipped(:final reason) => l10n.activityTaskSkipped(
      name,
      task,
      reason.label(l10n),
    ),
    MemberInvited(:final role) => l10n.activityMemberInvited(
      name,
      member,
      role.label(l10n),
    ),
    InvitationRevoked() => l10n.activityInvitationRevoked(name, member),
    MemberJoined() => l10n.activityMemberJoined(member),
    RoleChanged(:final role) => l10n.activityRoleChanged(
      name,
      member,
      role.label(l10n),
    ),
    MemberRemoved() => l10n.activityMemberRemoved(name, member),
    MemberLeft() => l10n.activityMemberLeft(member),
    RecipientProfileUpdated() => l10n.activityProfileUpdated(name),
    ConflictAcknowledged() => l10n.activityReviewed(name),
  };
}
