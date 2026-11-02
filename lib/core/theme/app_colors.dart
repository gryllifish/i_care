import 'package:flutter/material.dart';

/// Color tokens, as a theme extension with a light and a dark palette.
/// Widgets read them with `context.colors`.
///
/// Text on every surface keeps a contrast ratio of at least 4.5:1 in both
/// palettes, and status colors are always paired with an icon and a label,
/// never used alone. Accent fills ([teal], [overdue], [given], the avatars)
/// carry [onAccent] content: white on deep colors in light, dark on pale
/// colors in dark.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceMuted,
    required this.divider,
    required this.backdrop,
    required this.shadow,
    required this.frameShadow,
    required this.ink,
    required this.inkMuted,
    required this.onAccent,
    required this.hero,
    required this.heroLate,
    required this.onHero,
    required this.onHeroMuted,
    required this.teal,
    required this.tealDark,
    required this.tealSoft,
    required this.recipient,
    required this.given,
    required this.givenSoft,
    required this.due,
    required this.dueSoft,
    required this.overdue,
    required this.overdueSoft,
    required this.overdueDark,
    required this.skipped,
    required this.skippedSoft,
    required this.avatars,
  });

  /// Soft green-gray surfaces and a deep teal accent.
  static const light = AppColors(
    background: Color(0xFFF2F5F4),
    surface: Color(0xFFFFFFFF),
    surfaceMuted: Color(0xFFE9EFED),
    divider: Color(0xFFDCE3E1),
    backdrop: Color(0xFFDDE5E2),
    shadow: Color(0x1A14211E),
    frameShadow: Color(0x3314211E),
    ink: Color(0xFF14211E),
    inkMuted: Color(0xFF55635F),
    onAccent: Color(0xFFFFFFFF),
    hero: [Color(0xFF1E6A64), Color(0xFF134B46)],
    heroLate: [Color(0xFFB3261E), Color(0xFF8E1F18)],
    onHero: Color(0xFFFFFFFF),
    onHeroMuted: Color(0xD9FFFFFF),
    teal: Color(0xFF1E6A64),
    tealDark: Color(0xFF134B46),
    tealSoft: Color(0xFFD6ECE8),
    recipient: Color(0xFFB4683C),
    given: Color(0xFF2B6B44),
    givenSoft: Color(0xFFDAEFE1),
    due: Color(0xFF8A5A00),
    dueSoft: Color(0xFFFBEBC8),
    overdue: Color(0xFFB3261E),
    overdueSoft: Color(0xFFFADCD9),
    overdueDark: Color(0xFF8E1F18),
    skipped: Color(0xFF55635F),
    skippedSoft: Color(0xFFE6EBE9),
    avatars: [Color(0xFF1E6A64), Color(0xFF6B4BA1), Color(0xFF9C4A2C)],
  );

  /// Deep green-black surfaces and pale accents, for doses given at night.
  static const dark = AppColors(
    background: Color(0xFF0E1513),
    surface: Color(0xFF19221F),
    surfaceMuted: Color(0xFF222D2A),
    divider: Color(0xFF2F3B38),
    backdrop: Color(0xFF080C0B),
    shadow: Color(0x66000000),
    frameShadow: Color(0x99000000),
    ink: Color(0xFFE3ECE9),
    inkMuted: Color(0xFFA2B1AD),
    onAccent: Color(0xFF0B1F1C),
    hero: [Color(0xFF1E4C46), Color(0xFF143430)],
    heroLate: [Color(0xFF5A2420), Color(0xFF3D1815)],
    onHero: Color(0xFFE8F4F1),
    onHeroMuted: Color(0xCCE8F4F1),
    teal: Color(0xFF7DCFC4),
    tealDark: Color(0xFFA8E6DC),
    tealSoft: Color(0xFF1D3A36),
    recipient: Color(0xFFE8A77F),
    given: Color(0xFF8FD3A3),
    givenSoft: Color(0xFF1B3526),
    due: Color(0xFFF0C46A),
    dueSoft: Color(0xFF3A2C0C),
    overdue: Color(0xFFF4A69F),
    overdueSoft: Color(0xFF45201D),
    overdueDark: Color(0xFFFFD3CE),
    skipped: Color(0xFFA2B1AD),
    skippedSoft: Color(0xFF27312F),
    avatars: [Color(0xFF7DCFC4), Color(0xFFC4ADEF), Color(0xFFEFAA8C)],
  );

  // Surfaces
  final Color background;
  final Color surface;
  final Color surfaceMuted;
  final Color divider;

  /// Page behind the phone frames on wide screens (web on desktop).
  final Color backdrop;
  final Color shadow;
  final Color frameShadow;

  // Text
  final Color ink;
  final Color inkMuted;

  /// Text and icons on accent fills.
  final Color onAccent;

  /// The next-dose card's gradient, and the late one. Deep in both
  /// palettes: a bright card would glare at night.
  final List<Color> hero;
  final List<Color> heroLate;

  /// Text on [hero] and [heroLate].
  final Color onHero;
  final Color onHeroMuted;

  // Accent
  final Color teal;

  /// Text and icons on [tealSoft].
  final Color tealDark;
  final Color tealSoft;

  /// Warm tone for the care recipient's avatar.
  final Color recipient;

  // Dose status
  final Color given;
  final Color givenSoft;
  final Color due;
  final Color dueSoft;
  final Color overdue;
  final Color overdueSoft;

  /// Text on [overdueSoft].
  final Color overdueDark;
  final Color skipped;
  final Color skippedSoft;

  /// Member avatars, picked by `Member.colorIndex`.
  final List<Color> avatars;

  /// The palette is fixed per brightness: nothing customizes single tokens.
  @override
  AppColors copyWith() => this;

  /// Blends every token, so switching themes animates smoothly.
  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t) ?? b;
    List<Color> mixAll(List<Color> a, List<Color> b) => [
      for (final (index, color) in a.indexed) mix(color, b[index]),
    ];
    return AppColors(
      background: mix(background, other.background),
      surface: mix(surface, other.surface),
      surfaceMuted: mix(surfaceMuted, other.surfaceMuted),
      divider: mix(divider, other.divider),
      backdrop: mix(backdrop, other.backdrop),
      shadow: mix(shadow, other.shadow),
      frameShadow: mix(frameShadow, other.frameShadow),
      ink: mix(ink, other.ink),
      inkMuted: mix(inkMuted, other.inkMuted),
      onAccent: mix(onAccent, other.onAccent),
      hero: mixAll(hero, other.hero),
      heroLate: mixAll(heroLate, other.heroLate),
      onHero: mix(onHero, other.onHero),
      onHeroMuted: mix(onHeroMuted, other.onHeroMuted),
      teal: mix(teal, other.teal),
      tealDark: mix(tealDark, other.tealDark),
      tealSoft: mix(tealSoft, other.tealSoft),
      recipient: mix(recipient, other.recipient),
      given: mix(given, other.given),
      givenSoft: mix(givenSoft, other.givenSoft),
      due: mix(due, other.due),
      dueSoft: mix(dueSoft, other.dueSoft),
      overdue: mix(overdue, other.overdue),
      overdueSoft: mix(overdueSoft, other.overdueSoft),
      overdueDark: mix(overdueDark, other.overdueDark),
      skipped: mix(skipped, other.skipped),
      skippedSoft: mix(skippedSoft, other.skippedSoft),
      avatars: mixAll(avatars, other.avatars),
    );
  }
}

extension AppColorsContext on BuildContext {
  /// The current palette. The app theme always registers one; light is a
  /// fallback only for widgets pumped without it.
  AppColors get colors =>
      Theme.of(this).extension<AppColors>() ?? AppColors.light;
}
