// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(phoneCaller)
final phoneCallerProvider = PhoneCallerProvider._();

final class PhoneCallerProvider
    extends $FunctionalProvider<PhoneCaller, PhoneCaller, PhoneCaller>
    with $Provider<PhoneCaller> {
  PhoneCallerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'phoneCallerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$phoneCallerHash();

  @$internal
  @override
  $ProviderElement<PhoneCaller> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PhoneCaller create(Ref ref) {
    return phoneCaller(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PhoneCaller value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PhoneCaller>(value),
    );
  }
}

String _$phoneCallerHash() => r'41c64dc493f0309ccab424d59d0cd1c39dc262ea';
