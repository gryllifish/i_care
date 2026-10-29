import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/utils/formatters.dart';

/// "Today, 10:30", "Tomorrow, 10:30", or "Thursday, 10:30" within a week;
/// "Nov 12, 10:30" beyond.
String appointmentWhen(
  AppLocalizations l10n,
  DateTime startsAt, {
  required DateTime now,
  required String locale,
}) {
  final time = Formatters.time(startsAt, locale);
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(startsAt.year, startsAt.month, startsAt.day);
  final daysAway = day.difference(today).inDays;
  return switch (daysAway) {
    0 => l10n.todayAt(time),
    1 => l10n.tomorrowAt(time),
    > 1 && < DateTime.daysPerWeek => l10n.dayAt(
      Formatters.weekdayName(startsAt, locale),
      time,
    ),
    _ => l10n.dayAt(Formatters.shortDate(startsAt, locale), time),
  };
}
