import 'package:flutter/material.dart';

/// Type scale in Atkinson Hyperlegible Next, designed by the Braille
/// Institute for readers with low vision. Sizes start one step above
/// Material's defaults: the app is read in a hurry, often by older
/// caregivers.
abstract final class AppTextStyles {
  static const fontFamily = 'AtkinsonHyperlegibleNext';

  static const display = TextStyle(
    fontFamily: fontFamily,
    fontSize: 34,
    fontWeight: FontWeight.w700,
    height: 1.1,
    letterSpacing: -0.5,
  );

  static const headline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    height: 1.15,
    letterSpacing: -0.3,
  );

  static const title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 19,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );

  static const body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    height: 1.4,
  );

  static const bodyMuted = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    height: 1.35,
  );

  static const label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  /// Small caps-like label above a value ("NEXT DOSE").
  static const overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
  );

  /// Text inside status pills and badges.
  static const pill = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.1,
  );
}
