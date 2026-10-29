// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Lives in `app/` (not `core/`) because it imports every feature's screens;
/// `core` must never depend on features.
///
/// `routerNeglect` keeps navigation out of the browser history: the web
/// demo runs two phones, each with its own router, on one page, and the
/// browser's back button must not move both at once.

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// Lives in `app/` (not `core/`) because it imports every feature's screens;
/// `core` must never depend on features.
///
/// `routerNeglect` keeps navigation out of the browser history: the web
/// demo runs two phones, each with its own router, on one page, and the
/// browser's back button must not move both at once.

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// Lives in `app/` (not `core/`) because it imports every feature's screens;
  /// `core` must never depend on features.
  ///
  /// `routerNeglect` keeps navigation out of the browser history: the web
  /// demo runs two phones, each with its own router, on one page, and the
  /// browser's back button must not move both at once.
  AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$appRouterHash() => r'030d32c3e0de1f35b524876678af2fbccdc48c75';
