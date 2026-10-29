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

  /// "Nov 2" / "2 nov".
  static String shortDate(DateTime day, String locale) =>
      DateFormat.MMMd(locale).format(day);

  /// "Mon" / "lun" for a `DateTime.monday`..`DateTime.sunday` weekday.
  static String weekday(int weekday, String locale) =>
      // 2024-01-01 was a Monday.
      DateFormat.E(locale).format(DateTime(2024, 1, weekday));

  /// "28", "0.5" or "1,5", as the locale writes numbers.
  static String units(double units, String locale) =>
      NumberFormat.decimalPattern(locale).format(units);
}
