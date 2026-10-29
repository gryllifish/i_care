import 'package:flutter/material.dart';

/// Color tokens: calm neutrals and one deep teal accent. Text on every
/// surface keeps a contrast ratio of at least 4.5:1, and status colors are
/// always paired with an icon and a label, never used alone.
abstract final class AppColors {
  // Surfaces
  static const background = Color(0xFFF5F6F4);
  static const surface = Color(0xFFFFFFFF);
  static const divider = Color(0xFFDDE1DE);

  /// Page behind the phone frame on wide screens (web on desktop).
  static const backdrop = Color(0xFFE3E7E4);
  static const frameShadow = Color(0x33172320);

  // Text
  static const ink = Color(0xFF172320);
  static const inkMuted = Color(0xFF55615D);
  static const onAccent = Color(0xFFFFFFFF);

  // Accent
  static const teal = Color(0xFF1F5F5B);
  static const tealSoft = Color(0xFFD7E8E5);

  // Dose status
  static const given = Color(0xFF2E6B45);
  static const givenSoft = Color(0xFFDCEDE1);
  static const due = Color(0xFF8A5A00);
  static const dueSoft = Color(0xFFF7E9CC);
  static const overdue = Color(0xFFB3261E);
  static const overdueSoft = Color(0xFFF9DEDC);
}
