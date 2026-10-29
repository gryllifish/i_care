// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication_detail.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(medicationDetail)
final medicationDetailProvider = MedicationDetailFamily._();

final class MedicationDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<MedicationDetail?>,
          AsyncValue<MedicationDetail?>,
          AsyncValue<MedicationDetail?>
        >
    with $Provider<AsyncValue<MedicationDetail?>> {
  MedicationDetailProvider._({
    required MedicationDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'medicationDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$medicationDetailHash();

  @override
  String toString() {
    return r'medicationDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<MedicationDetail?>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<MedicationDetail?> create(Ref ref) {
    final argument = this.argument as String;
    return medicationDetail(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<MedicationDetail?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<MedicationDetail?>>(
        value,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MedicationDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$medicationDetailHash() => r'b7ae957ef198ab3d13c9de18594c4b674eca14e3';

final class MedicationDetailFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<MedicationDetail?>, String> {
  MedicationDetailFamily._()
    : super(
        retry: null,
        name: r'medicationDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MedicationDetailProvider call(String medicationId) =>
      MedicationDetailProvider._(argument: medicationId, from: this);

  @override
  String toString() => r'medicationDetailProvider';
}

/// Medications with concurrent edits nobody has reviewed, for the list.

@ProviderFor(medicationConflicts)
final medicationConflictsProvider = MedicationConflictsProvider._();

/// Medications with concurrent edits nobody has reviewed, for the list.

final class MedicationConflictsProvider
    extends
        $FunctionalProvider<
          AsyncValue<ConflictsByMedication>,
          AsyncValue<ConflictsByMedication>,
          AsyncValue<ConflictsByMedication>
        >
    with $Provider<AsyncValue<ConflictsByMedication>> {
  /// Medications with concurrent edits nobody has reviewed, for the list.
  MedicationConflictsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'medicationConflictsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$medicationConflictsHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<ConflictsByMedication>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<ConflictsByMedication> create(Ref ref) {
    return medicationConflicts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<ConflictsByMedication> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<ConflictsByMedication>>(
        value,
      ),
    );
  }
}

String _$medicationConflictsHash() =>
    r'fd9daee40f44cd093ab4b0867285d7e8f23091ec';
