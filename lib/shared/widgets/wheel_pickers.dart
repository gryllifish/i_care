import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:i_care/core/l10n/l10n.dart';
import 'package:i_care/core/theme/app_colors.dart';
import 'package:i_care/core/theme/app_spacing.dart';
import 'package:i_care/core/theme/app_text_styles.dart';

/// Picks a time with a scroll wheel in a bottom sheet: simpler than
/// Material's dial, and the same on Android and iOS. Minutes move in
/// steps of [minuteInterval]; 24 h, like every time the app shows.
Future<TimeOfDay?> showTimeWheel(
  BuildContext context, {
  required TimeOfDay initial,
  int minuteInterval = 1,
}) async {
  final rounded = initial.minute - initial.minute % minuteInterval;
  final picked = await _showWheel(
    context,
    mode: CupertinoDatePickerMode.time,
    initial: DateTime(2024, 1, 1, initial.hour, rounded),
    minuteInterval: minuteInterval,
  );
  return picked == null ? null : TimeOfDay.fromDateTime(picked);
}

/// Picks a day between [first] and [last] with a scroll wheel.
Future<DateTime?> showDateWheel(
  BuildContext context, {
  required DateTime initial,
  required DateTime first,
  required DateTime last,
}) => _showWheel(
  context,
  mode: CupertinoDatePickerMode.date,
  initial: initial,
  minimum: first,
  maximum: last,
);

Future<DateTime?> _showWheel(
  BuildContext context, {
  required CupertinoDatePickerMode mode,
  required DateTime initial,
  int minuteInterval = 1,
  DateTime? minimum,
  DateTime? maximum,
}) {
  var value = initial;
  return showModalBottomSheet<DateTime>(
    context: context,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          0,
          AppSpacing.xl,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.lg,
          children: [
            SizedBox(
              height: _wheelHeight,
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: AppTextStyles.headline.copyWith(
                      color: context.colors.ink,
                    ),
                  ),
                ),
                child: CupertinoDatePicker(
                  mode: mode,
                  initialDateTime: initial,
                  minuteInterval: minuteInterval,
                  use24hFormat: true,
                  minimumDate: minimum,
                  maximumDate: maximum,
                  itemExtent: _itemExtent,
                  onDateTimeChanged: (picked) => value = picked,
                ),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(value),
              child: Text(context.l10n.done),
            ),
          ],
        ),
      ),
    ),
  );
}

const _wheelHeight = 220.0;
const _itemExtent = 44.0;
