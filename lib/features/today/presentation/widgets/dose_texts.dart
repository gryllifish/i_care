import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/utils/formatters.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/features/care/domain/projections/dose_warnings.dart';
import 'package:i_care/features/today/controllers/today_view.dart';

/// "Ana at 08:04", or "Ana, today at 08:04" when a dose scheduled on an
/// earlier day was recorded [today], so it is not read as that day's time.
String recordedByText(
  AppLocalizations l10n, {
  required String name,
  required DateTime at,
  required DateTime? slotAt,
  required DateTime today,
  required String locale,
}) {
  final time = Formatters.time(at, locale);
  final recordedLater =
      slotAt != null && !_isSameDay(at, slotAt) && _isSameDay(at, today);
  return recordedLater
      ? l10n.recordedByToday(name, time)
      : l10n.recordedBy(name, time);
}

/// Who recorded each dose in a conflict, and when.
String conflictRecordsText(
  AppLocalizations l10n, {
  required ConflictItem item,
  required Map<String, Member> caregivers,
  required DateTime today,
  required String locale,
}) => [
  for (final dose in item.conflict.doses)
    recordedByText(
      l10n,
      name: caregivers[dose.meta.caregiverId]?.name ?? l10n.unknownCaregiver,
      at: dose.givenAt,
      slotAt: dose.slotAt,
      today: today,
      locale: locale,
    ),
].join(' · ');

extension ConflictItemTitle on ConflictItem {
  String title(AppLocalizations l10n, String locale) {
    final name = medication.details.name;
    return switch (slotAt) {
      final DateTime slotAt => l10n.conflictSlotTitle(
        name,
        Formatters.time(slotAt, locale),
        conflict.doses.length,
      ),
      null => l10n.conflictCloseTitle(name),
    };
  }
}

bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

extension DoseWarningText on DoseWarning {
  String text(
    AppLocalizations l10n, {
    required String locale,
    required Map<String, Member> caregivers,
  }) {
    String time(DateTime value) => Formatters.time(value, locale);
    String nameOf(String id) => caregivers[id]?.name ?? l10n.unknownCaregiver;

    return switch (this) {
      // The latest record; the sheet lists every one above.
      AlreadyGiven(:final doses) => l10n.warningAlreadyGiven(
        nameOf(doses.last.meta.caregiverId),
        time(doses.last.givenAt),
      ),
      TooSoon(:final lastDose, :final allowedFrom) => l10n.warningTooSoon(
        time(lastDose.givenAt),
        time(allowedFrom),
      ),
      DailyLimitReached(:final given, :final max) => l10n.warningDailyLimit(
        given,
        max,
      ),
      Offline() => l10n.warningOffline,
      OutOfDate(lastSyncedAt: final DateTime at) => l10n.warningOutOfDate(
        time(at),
      ),
      OutOfDate() => l10n.warningNeverSynced,
    };
  }
}
