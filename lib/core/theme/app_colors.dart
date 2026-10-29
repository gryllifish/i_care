import 'package:flutter/material.dart';

/// Color tokens: soft green-gray surfaces and a deep teal accent. Text on
/// every surface keeps a contrast ratio of at least 4.5:1, and status
/// colors are always paired with an icon and a label, never used alone.
abstract final class AppColors {
  // Surfaces
  static const background = Color(0xFFF2F5F4);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFE9EFED);
  static const divider = Color(0xFFDCE3E1);

  /// Page behind the phone frames on wide screens (web on desktop).
  static const backdrop = Color(0xFFDDE5E2);
  static const shadow = Color(0x1A14211E);
  static const frameShadow = Color(0x3314211E);

  // Text
  static const ink = Color(0xFF14211E);
  static const inkMuted = Color(0xFF55635F);
  static const onAccent = Color(0xFFFFFFFF);
  static const onAccentMuted = Color(0xD9FFFFFF);

  // Accent
  static const teal = Color(0xFF1E6A64);
  static const tealDark = Color(0xFF134B46);
  static const tealSoft = Color(0xFFD6ECE8);

  /// Warm tone for the care recipient's avatar.
  static const recipient = Color(0xFFB4683C);

  // Dose status
  static const given = Color(0xFF2B6B44);
  static const givenSoft = Color(0xFFDAEFE1);
  static const due = Color(0xFF8A5A00);
  static const dueSoft = Color(0xFFFBEBC8);
  static const overdue = Color(0xFFB3261E);
  static const overdueSoft = Color(0xFFFADCD9);
  static const overdueDark = Color(0xFF8E1F18);
  static const skipped = Color(0xFF55635F);
  static const skippedSoft = Color(0xFFE6EBE9);

  /// Caregiver avatars, picked by `Caregiver.colorIndex`.
  static const avatars = [
    Color(0xFF1E6A64),
    Color(0xFF6B4BA1),
    Color(0xFF9C4A2C),
  ];
}
