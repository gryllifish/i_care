// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_prefs.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// This device's preferences; `bootstrap` overrides it with Hive.

@ProviderFor(devicePrefs)
final devicePrefsProvider = DevicePrefsProvider._();

/// This device's preferences; `bootstrap` overrides it with Hive.

final class DevicePrefsProvider
    extends $FunctionalProvider<DevicePrefs, DevicePrefs, DevicePrefs>
    with $Provider<DevicePrefs> {
  /// This device's preferences; `bootstrap` overrides it with Hive.
  DevicePrefsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'devicePrefsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$devicePrefsHash();

  @$internal
  @override
  $ProviderElement<DevicePrefs> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DevicePrefs create(Ref ref) {
    return devicePrefs(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DevicePrefs value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DevicePrefs>(value),
    );
  }
}

String _$devicePrefsHash() => r'9b077bd587a5aa1feb9872755b3f8f8adab55881';
