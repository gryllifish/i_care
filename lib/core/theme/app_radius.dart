import 'package:flutter/widgets.dart';

/// Corner radius scale.
abstract final class AppRadius {
  static const double sm = 12;
  static const double md = 20;
  static const double lg = 28;

  /// Fully rounded ends for pills and buttons.
  static const double pill = 999;
  static final BorderRadius pillBorder = BorderRadius.circular(pill);

  /// Corners of the phone frame shown on wide screens.
  static const double device = 44;

  /// Top corners of bottom sheets.
  static const BorderRadius sheetTop = BorderRadius.vertical(
    top: Radius.circular(lg),
  );
}
