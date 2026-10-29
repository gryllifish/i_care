import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';
import 'package:i_care/features/care/domain/entities/medication_validation.dart';

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
