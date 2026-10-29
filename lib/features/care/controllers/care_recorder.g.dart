// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'care_recorder.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(careRecorder)
final careRecorderProvider = CareRecorderProvider._();

final class CareRecorderProvider
    extends $FunctionalProvider<CareRecorder, CareRecorder, CareRecorder>
    with $Provider<CareRecorder> {
  CareRecorderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'careRecorderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$careRecorderHash();

  @$internal
  @override
  $ProviderElement<CareRecorder> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CareRecorder create(Ref ref) {
    return careRecorder(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CareRecorder value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CareRecorder>(value),
    );
  }
}

String _$careRecorderHash() => r'4dbdbf69ea44af69123f046f1602eb9f9779c89c';
