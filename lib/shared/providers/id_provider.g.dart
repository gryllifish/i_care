// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'id_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Generates ids that are unique across devices without asking a server;
/// tests override it with predictable ids.

@ProviderFor(newId)
final newIdProvider = NewIdProvider._();

/// Generates ids that are unique across devices without asking a server;
/// tests override it with predictable ids.

final class NewIdProvider
    extends
        $FunctionalProvider<
          String Function(),
          String Function(),
          String Function()
        >
    with $Provider<String Function()> {
  /// Generates ids that are unique across devices without asking a server;
  /// tests override it with predictable ids.
  NewIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newIdHash();

  @$internal
  @override
  $ProviderElement<String Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  String Function() create(Ref ref) {
    return newId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String Function()>(value),
    );
  }
}

String _$newIdHash() => r'a81eb967ac653ad2c956013066fbcf4237340069';
