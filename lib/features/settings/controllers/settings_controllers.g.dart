// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The language chosen for this phone; null follows the system.

@ProviderFor(AppLanguage)
final appLanguageProvider = AppLanguageProvider._();

/// The language chosen for this phone; null follows the system.
final class AppLanguageProvider
    extends $NotifierProvider<AppLanguage, Locale?> {
  /// The language chosen for this phone; null follows the system.
  AppLanguageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appLanguageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appLanguageHash();

  @$internal
  @override
  AppLanguage create() => AppLanguage();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale?>(value),
    );
  }
}

String _$appLanguageHash() => r'1b3819e9cbfd98748898fcfd1190f7d9c8c0465c';

/// The language chosen for this phone; null follows the system.

abstract class _$AppLanguage extends $Notifier<Locale?> {
  Locale? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Locale?, Locale?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale?, Locale?>,
              Locale?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Whether this phone already showed the welcome.

@ProviderFor(WelcomeSeen)
final welcomeSeenProvider = WelcomeSeenProvider._();

/// Whether this phone already showed the welcome.
final class WelcomeSeenProvider extends $NotifierProvider<WelcomeSeen, bool> {
  /// Whether this phone already showed the welcome.
  WelcomeSeenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'welcomeSeenProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$welcomeSeenHash();

  @$internal
  @override
  WelcomeSeen create() => WelcomeSeen();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$welcomeSeenHash() => r'8a846037af443249eb786ac3bdc60c240ea6496d';

/// Whether this phone already showed the welcome.

abstract class _$WelcomeSeen extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(demoReset)
final demoResetProvider = DemoResetProvider._();

final class DemoResetProvider
    extends $FunctionalProvider<DemoReset, DemoReset, DemoReset>
    with $Provider<DemoReset> {
  DemoResetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'demoResetProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$demoResetHash();

  @$internal
  @override
  $ProviderElement<DemoReset> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DemoReset create(Ref ref) {
    return demoReset(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DemoReset value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DemoReset>(value),
    );
  }
}

String _$demoResetHash() => r'cea7277252f8d34940a8469fec82785e2082acab';
