import 'package:intl/intl.dart';

/// Locale-aware display formatting. Pure functions, so widgets may use
/// them directly.
abstract final class Formatters {
  /// "08:05".
  static String time(DateTime time, String locale) =>
      DateFormat.Hm(locale).format(time);

  /// "Monday, November 2" / "lunes, 2 de noviembre".
  static String longDay(DateTime day, String locale) =>
      DateFormat.MMMMEEEEd(locale).format(day);

  /// "Mar 14, 1942" / "14 mar 1942", for dates far from today.
  static String fullDate(DateTime day, String locale) =>
      DateFormat.yMMMd(locale).format(day);

  /// "Nov 2" / "2 nov".
  static String shortDate(DateTime day, String locale) =>
      DateFormat.MMMd(locale).format(day);

  /// "Thursday" / "jueves".
  static String weekdayName(DateTime day, String locale) =>
      DateFormat.EEEE(locale).format(day);

  /// "4", the day of the month.
  static String dayOfMonth(DateTime day, String locale) =>
      DateFormat.d(locale).format(day);

  /// "NOV" / "NOV.", the month in a date badge.
  static String monthBadge(DateTime day, String locale) =>
      DateFormat.MMM(locale).format(day).toUpperCase();

  /// "Mon" / "lun" for a `DateTime.monday`..`DateTime.sunday` weekday.
  static String weekday(int weekday, String locale) =>
      // 2024-01-01 was a Monday.
      DateFormat.E(locale).format(DateTime(2024, 1, weekday));

  /// "28", "0.5" or "1,5", as the locale writes numbers.
  static String units(double units, String locale) =>
      NumberFormat.decimalPattern(locale).format(units);
}
