// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medications_view.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Active medications by name, each with its stock.

@ProviderFor(medicationsView)
final medicationsViewProvider = MedicationsViewProvider._();

/// Active medications by name, each with its stock.

final class MedicationsViewProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MedicationRow>>,
          AsyncValue<List<MedicationRow>>,
          AsyncValue<List<MedicationRow>>
        >
    with $Provider<AsyncValue<List<MedicationRow>>> {
  /// Active medications by name, each with its stock.
  MedicationsViewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'medicationsViewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$medicationsViewHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<MedicationRow>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<MedicationRow>> create(Ref ref) {
    return medicationsView(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<MedicationRow>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<MedicationRow>>>(
        value,
      ),
    );
  }
}

String _$medicationsViewHash() => r'a0fdf68af57d3a720f2ef77f9964ab6d5d6d644e';
