import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';
import 'package:i_care/features/care/domain/entities/medication_validation.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/features/care/domain/entities/rejected_event.dart';
import 'package:i_care/features/care/domain/entities/task_validation.dart';

/// A skip reason by id: a standard one translated, the circle's as it
/// was written ([customReasons]); "Other" when unknown.
String reasonLabel(
  AppLocalizations l10n,
  String reasonId, {
  required Map<String, String> customReasons,
}) =>
    SkipReason.byId(reasonId)?.label(l10n) ??
    customReasons[reasonId] ??
    l10n.skipOther;

/// Why a dose was not given or a task not done, as people read it: the
/// reason, and what the caregiver wrote. A note on "Other" says it all.
String skipText(
  AppLocalizations l10n, {
  required String reasonId,
  required String? note,
  required Map<String, String> customReasons,
}) {
  final label = reasonLabel(l10n, reasonId, customReasons: customReasons);
  final said = note?.trim() ?? '';
  if (said.isEmpty) return label;
  return reasonId == SkipReason.other.id ? said : '$label ($said)';
}

extension SkipReasonLabel on SkipReason {
  String label(AppLocalizations l10n) => switch (this) {
    SkipReason.refused => l10n.skipRefused,
    SkipReason.asleep => l10n.skipAsleep,
    SkipReason.unwell => l10n.skipUnwell,
    SkipReason.doctorAdvice => l10n.skipDoctorAdvice,
    SkipReason.other => l10n.skipOther,
  };
}

extension MedicationFormLabel on MedicationForm {
  String label(AppLocalizations l10n) => switch (this) {
    MedicationForm.tablet => l10n.formTablet,
    MedicationForm.capsule => l10n.formCapsule,
    MedicationForm.liquid => l10n.formLiquid,
    MedicationForm.drops => l10n.formDrops,
    MedicationForm.injection => l10n.formInjection,
    MedicationForm.patch => l10n.formPatch,
    MedicationForm.inhaler => l10n.formInhaler,
    MedicationForm.other => l10n.formOther,
  };
}

extension MedicationIssueMessage on MedicationIssue {
  String message(AppLocalizations l10n) => switch (this) {
    MedicationIssue.nameMissing => l10n.issueNameMissing,
    MedicationIssue.unitsPerDoseNotPositive => l10n.issueUnitsPerDose,
    MedicationIssue.lowStockDaysNegative => l10n.issueStockNumber,
    MedicationIssue.noTimes => l10n.issueNoTimes,
    MedicationIssue.noWeekdays => l10n.issueNoWeekdays,
    MedicationIssue.minIntervalNotPositive => l10n.issueMinInterval,
    MedicationIssue.maxPerDayNotPositive => l10n.issueMaxPerDay,
  };
}

extension TaskIssueMessage on TaskIssue {
  String message(AppLocalizations l10n) => switch (this) {
    TaskIssue.nameMissing => l10n.issueNameMissing,
    TaskIssue.noTimes => l10n.issueNoTimes,
    TaskIssue.noWeekdays => l10n.issueNoWeekdays,
  };
}

extension MemberRoleLabel on MemberRole {
  String label(AppLocalizations l10n) => switch (this) {
    MemberRole.admin => l10n.roleAdmin,
    MemberRole.caregiver => l10n.roleCaregiver,
    MemberRole.helper => l10n.roleHelper,
    MemberRole.viewer => l10n.roleViewer,
  };

  /// What the role may do, in one line.
  String about(AppLocalizations l10n) => switch (this) {
    MemberRole.admin => l10n.roleAdminAbout,
    MemberRole.caregiver => l10n.roleCaregiverAbout,
    MemberRole.helper => l10n.roleHelperAbout,
    MemberRole.viewer => l10n.roleViewerAbout,
  };
}

extension RejectionReasonText on RejectionReason {
  String text(AppLocalizations l10n) => switch (this) {
    RejectionReason.wrongAuthor => l10n.rejectedWrongAuthor,
    RejectionReason.notAllowed => l10n.rejectedNotAllowed,
    RejectionReason.notMember => l10n.rejectedNotMember,
    RejectionReason.lastAdmin => l10n.rejectedLastAdmin,
  };
}
