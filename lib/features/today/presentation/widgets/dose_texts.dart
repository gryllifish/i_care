import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/utils/formatters.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/caregiver.dart';
import 'package:i_care/features/care/domain/projections/dose_warnings.dart';

extension SkipReasonLabel on SkipReason {
  String label(AppLocalizations l10n) => switch (this) {
    SkipReason.refused => l10n.skipRefused,
    SkipReason.asleep => l10n.skipAsleep,
    SkipReason.unwell => l10n.skipUnwell,
    SkipReason.doctorAdvice => l10n.skipDoctorAdvice,
    SkipReason.other => l10n.skipOther,
  };
}

extension DoseWarningText on DoseWarning {
  String text(
    AppLocalizations l10n, {
    required String locale,
    required Map<String, Caregiver> caregivers,
  }) {
    String time(DateTime value) => Formatters.time(value, locale);
    String nameOf(String id) => caregivers[id]?.name ?? l10n.unknownCaregiver;

    return switch (this) {
      AlreadyGiven(:final dose) => l10n.warningAlreadyGiven(
        nameOf(dose.meta.caregiverId),
        time(dose.givenAt),
      ),
      TooSoon(:final lastDose, :final allowedFrom) => l10n.warningTooSoon(
        time(lastDose.givenAt),
        time(allowedFrom),
      ),
      DailyLimitReached(:final given, :final max) => l10n.warningDailyLimit(
        given,
        max,
      ),
      OutOfDate(lastSyncedAt: final DateTime at) => l10n.warningOutOfDate(
        time(at),
      ),
      OutOfDate() => l10n.warningNeverSynced,
    };
  }
}
