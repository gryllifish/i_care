// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'now_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The current time, refreshed every [nowTick]. Widgets and derived state
/// watch this; actions read `clockProvider` for the exact moment.

@ProviderFor(Now)
final nowProvider = NowProvider._();

/// The current time, refreshed every [nowTick]. Widgets and derived state
/// watch this; actions read `clockProvider` for the exact moment.
final class NowProvider extends $NotifierProvider<Now, DateTime> {
  /// The current time, refreshed every [nowTick]. Widgets and derived state
  /// watch this; actions read `clockProvider` for the exact moment.
  NowProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nowProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nowHash();

  @$internal
  @override
  Now create() => Now();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$nowHash() => r'26fb7ac34215c2c87bbd63c1c9eb881896afe4ff';

/// The current time, refreshed every [nowTick]. Widgets and derived state
/// watch this; actions read `clockProvider` for the exact moment.

abstract class _$Now extends $Notifier<DateTime> {
  DateTime build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime, DateTime>,
              DateTime,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
