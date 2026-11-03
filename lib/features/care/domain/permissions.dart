import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/member.dart';

/// What a member can do, for the rule in [can] (`docs/roles.md`).
enum CareAction {
  /// Record a dose or task as given, done or skipped.
  recordCare,

  /// Take back one's own record.
  removeOwnRecord,

  /// Take back someone else's record.
  removeAnyRecord,

  /// Review a conflict, which may cancel others' repeated records.
  reviewConflict,

  /// Medications, schedules and stock.
  manageMedications,
  manageTasks,

  /// Appointments, visit notes and documents.
  manageAppointments,

  /// The circle's reasons for not giving a dose or doing a task.
  manageReasons,
  editEmergencyCard,

  /// Invite, revoke, change roles, remove.
  manageMembers,

  /// Unbind one's own device.
  leaveCircle,
  resetDemo,
}

/// The one permission rule, used by the UI to offer actions and by the
/// server to accept events.
bool can(MemberRole role, CareAction action) => switch (action) {
  CareAction.recordCare || CareAction.removeOwnRecord => switch (role) {
    MemberRole.admin || MemberRole.caregiver || MemberRole.helper => true,
    MemberRole.viewer => false,
  },
  CareAction.reviewConflict ||
  CareAction.manageMedications ||
  CareAction.manageTasks ||
  CareAction.manageAppointments ||
  CareAction.manageReasons ||
  CareAction.editEmergencyCard => switch (role) {
    MemberRole.admin || MemberRole.caregiver => true,
    MemberRole.helper || MemberRole.viewer => false,
  },
  CareAction.removeAnyRecord ||
  CareAction.manageMembers ||
  CareAction.resetDemo => role == MemberRole.admin,
  CareAction.leaveCircle => true,
};

/// The action [event] stands for when written by [authorId]; null for
/// events only the server writes ([MemberJoined]). [targetAuthorId] is
/// the author of the record an undo takes back, null when unknown.
CareAction? actionOf(
  CareEvent event, {
  required String authorId,
  String? targetAuthorId,
}) => switch (event) {
  DoseGiven() ||
  DoseSkipped() ||
  TaskDone() ||
  TaskSkipped() => CareAction.recordCare,
  DoseUndone(conflictKey: final String _) => CareAction.reviewConflict,
  DoseUndone() when targetAuthorId == authorId => CareAction.removeOwnRecord,
  DoseUndone() => CareAction.removeAnyRecord,
  ConflictAcknowledged() => CareAction.reviewConflict,
  MedicationCreated() ||
  MedicationUpdated() ||
  ScheduleChanged() ||
  MedicationArchived() ||
  StockCounted() ||
  StockRefilled() => CareAction.manageMedications,
  TaskCreated() || TaskUpdated() || TaskArchived() => CareAction.manageTasks,
  AppointmentCreated() ||
  AppointmentUpdated() ||
  AppointmentCancelled() ||
  VisitNoteAdded() ||
  DocumentLinked() ||
  DocumentRemoved() => CareAction.manageAppointments,
  RecipientProfileUpdated() => CareAction.editEmergencyCard,
  SkipReasonAdded() ||
  SkipReasonHidden() ||
  SkipReasonShown() => CareAction.manageReasons,
  MemberInvited() ||
  InvitationRevoked() ||
  RoleChanged() ||
  MemberRemoved() => CareAction.manageMembers,
  MemberLeft() => CareAction.leaveCircle,
  MemberJoined() || CircleCreated() => null,
};

/// Whether [action] records what happened to the person cared for: a dose
/// or task record, or taking back one's own. A fact from a device whose
/// member has left is still accepted, flagged, since it may be true and
/// losing it could lead to a second dose.
bool isFact(CareAction? action) => switch (action) {
  CareAction.recordCare || CareAction.removeOwnRecord => true,
  _ => false,
};

/// Whether [member] may take back [record]: their own, or anyone's for
/// an admin.
bool canRemove(Member member, CareEvent record) => can(
  member.role,
  record.meta.caregiverId == member.id
      ? CareAction.removeOwnRecord
      : CareAction.removeAnyRecord,
);

/// Whether [member] is the circle's only admin among [members]: they
/// cannot lose the role or leave the circle (`docs/roles.md`).
bool isLastAdmin(Iterable<Member> members, Member member) =>
    member.role == MemberRole.admin &&
    members.where((other) => other.role == MemberRole.admin).length <= 1;

/// Who may read an event (`docs/roles.md`, "Data by role").
enum Audience {
  /// What everyone needs to give care: medications, doses, tasks, the
  /// emergency card, members.
  care,

  /// The rest of the team's information: appointments, visit notes and
  /// documents.
  team,
}

/// [event]'s audience, decided by its type alone so the server can file
/// it when it arrives.
Audience audienceOf(CareEvent event) => switch (event) {
  AppointmentCreated() ||
  AppointmentUpdated() ||
  AppointmentCancelled() ||
  VisitNoteAdded() ||
  DocumentLinked() ||
  DocumentRemoved() => Audience.team,
  _ => Audience.care,
};

/// The audiences [role] reads.
Set<Audience> audiencesFor(MemberRole role) => switch (role) {
  MemberRole.helper => const {Audience.care},
  MemberRole.admin ||
  MemberRole.caregiver ||
  MemberRole.viewer => const {Audience.care, Audience.team},
};
