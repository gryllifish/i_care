import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';

extension SkipReasonLabel on SkipReason {
  String label(AppLocalizations l10n) => switch (this) {
    SkipReason.refused => l10n.skipRefused,
    SkipReason.asleep => l10n.skipAsleep,
    SkipReason.unwell => l10n.skipUnwell,
    SkipReason.doctorAdvice => l10n.skipDoctorAdvice,
    SkipReason.other => l10n.skipOther,
  };
}
