import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';
import 'package:i_care/core/config/demo_layout.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/core/utils/app_logger.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/data/care_providers.dart';
import 'package:i_care/features/care/domain/permissions.dart';
import 'package:i_care/features/care/domain/repositories/push_repository.dart';
import 'package:i_care/shared/providers/device_prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_controllers.g.dart';

/// The language chosen for this phone; null follows the system.
@Riverpod(keepAlive: true)
class AppLanguage extends _$AppLanguage {
  @override
  Locale? build() =>
      switch (ref.watch(devicePrefsProvider).read(PrefKeys.language)) {
        final String code => Locale(code),
        null => null,
      };

  Future<void> choose(Locale? locale) async {
    state = locale;
    await ref
        .read(devicePrefsProvider)
        .write(PrefKeys.language, locale?.languageCode);
  }
}

/// Light, dark, or following the system (the default) on this phone.
@Riverpod(keepAlive: true)
class AppThemeMode extends _$AppThemeMode {
  @override
  ThemeMode build() =>
      switch (ref.watch(devicePrefsProvider).read(PrefKeys.themeMode)) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  Future<void> choose(ThemeMode mode) async {
    state = mode;
    await ref
        .read(devicePrefsProvider)
        .write(PrefKeys.themeMode, mode == ThemeMode.system ? null : mode.name);
  }
}

/// Whether this phone already showed the welcome.
@Riverpod(keepAlive: true)
class WelcomeSeen extends _$WelcomeSeen {
  @override
  bool build() =>
      ref.watch(devicePrefsProvider).read(PrefKeys.welcomeSeen) == 'true';

  Future<void> markSeen() async {
    state = true;
    await ref.read(devicePrefsProvider).write(PrefKeys.welcomeSeen, 'true');
  }
}

/// Clears everything recorded on every simulated phone and on the server,
/// then loads the sample data again. `bootstrap` provides it, since only
/// it knows every phone.
typedef DemoReset = Future<void> Function();

@Riverpod(keepAlive: true)
DemoReset demoReset(Ref ref) =>
    () => throw UnimplementedError('Override demoResetProvider at startup');

/// Clears everything on every simulated phone and on the server, leaving
/// no circle: the demo as a first install. `bootstrap` provides it.
@Riverpod(keepAlive: true)
DemoReset demoStartEmpty(Ref ref) =>
    () =>
        throw UnimplementedError('Override demoStartEmptyProvider at startup');

/// Whether this is the demo, with simulated phones and sample data, or a
/// real phone syncing with a backend, where demo actions are not offered.
/// `bootstrap` provides it.
@Riverpod(keepAlive: true)
bool isDemo(Ref ref) => true;

/// How this demo shows its phones. `bootstrap` provides it.
@Riverpod(keepAlive: true)
DemoLayout demoLayout(Ref ref) => DemoLayout.twoPhones;

/// Whether this phone offers resetting the demo: an admin's, or the one
/// phone of the one-phone demo, which has no admin to ask.
@riverpod
bool canResetDemo(Ref ref) =>
    ref.watch(isDemoProvider) &&
    (ref.watch(demoLayoutProvider) == DemoLayout.onePhone ||
        ref.watch(canDoProvider(CareAction.resetDemo)));

/// This phone's notification permission, or null where there are no
/// push notifications (`docs/backend.md`). Lives with the app: on start
/// and when the language changes it keeps the phone's token on the
/// server, or has the server forget it once the permission is gone.
@Riverpod(keepAlive: true)
class PushNotifications extends _$PushNotifications {
  @override
  Future<PushPermission?> build() async {
    final repository = ref.watch(pushRepositoryProvider);
    if (repository == null) return null;
    ref.watch(appLanguageProvider);
    switch (await repository.sync(language: _pushLanguage(ref))) {
      case Ok(:final value):
        return value;
      case Err(:final failure):
        // Offline, say: synced on the next start; the answer still holds.
        AppLogger.warning('Push token not synced', failure);
        return switch (await repository.permission()) {
          Ok(:final value) => value,
          Err() => null,
        };
    }
  }

  /// Asks the system for permission; its dialog shows only the first time.
  Future<Result<void>> request() async {
    final repository = ref.read(pushRepositoryProvider);
    if (repository == null) return const Ok(null);
    final result = await repository.request(language: _pushLanguage(ref));
    if (result case Ok(:final value)) state = AsyncData(value);
    return result;
  }

  /// Asks only if the system never was: when someone starts using a
  /// circle. Its outcome shows in Settings; a failure is only logged.
  Future<void> askOnce() async {
    final permission = await future;
    if (permission != PushPermission.notAsked) return;
    if (await request() case Err(:final failure)) {
      AppLogger.warning('Notifications not requested', failure);
    }
  }
}

/// The language push messages use: the app's, `en` or `es`.
String _pushLanguage(Ref ref) => switch ((ref.read(appLanguageProvider) ??
        PlatformDispatcher.instance.locale)
    .languageCode) {
  'es' => 'es',
  _ => 'en',
};
