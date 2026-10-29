// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handoff.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(handoff)
final handoffProvider = HandoffProvider._();

final class HandoffProvider
    extends
        $FunctionalProvider<
          AsyncValue<Handoff>,
          AsyncValue<Handoff>,
          AsyncValue<Handoff>
        >
    with $Provider<AsyncValue<Handoff>> {
  HandoffProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'handoffProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$handoffHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<Handoff>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<Handoff> create(Ref ref) {
    return handoff(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<Handoff> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Handoff>>(value),
    );
  }
}

String _$handoffHash() => r'5ac39d58fd7911c348909ee93db924c1fb64c0e0';
