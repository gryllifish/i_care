// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dose_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The dose of [medicationId] scheduled at [slotAt] (null for as-needed
/// doses), kept current while the sheet is open.

@ProviderFor(doseDetail)
final doseDetailProvider = DoseDetailFamily._();

/// The dose of [medicationId] scheduled at [slotAt] (null for as-needed
/// doses), kept current while the sheet is open.

final class DoseDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<DoseDetail?>,
          AsyncValue<DoseDetail?>,
          AsyncValue<DoseDetail?>
        >
    with $Provider<AsyncValue<DoseDetail?>> {
  /// The dose of [medicationId] scheduled at [slotAt] (null for as-needed
  /// doses), kept current while the sheet is open.
  DoseDetailProvider._({
    required DoseDetailFamily super.from,
    required (String, DateTime?) super.argument,
  }) : super(
         retry: null,
         name: r'doseDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$doseDetailHash();

  @override
  String toString() {
    return r'doseDetailProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<DoseDetail?>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<DoseDetail?> create(Ref ref) {
    final argument = this.argument as (String, DateTime?);
    return doseDetail(ref, argument.$1, argument.$2);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<DoseDetail?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<DoseDetail?>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DoseDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$doseDetailHash() => r'52ead28f0d14453072353c483a2aa7f93654fcad';

/// The dose of [medicationId] scheduled at [slotAt] (null for as-needed
/// doses), kept current while the sheet is open.

final class DoseDetailFamily extends $Family
    with
        $FunctionalFamilyOverride<
          AsyncValue<DoseDetail?>,
          (String, DateTime?)
        > {
  DoseDetailFamily._()
    : super(
        retry: null,
        name: r'doseDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The dose of [medicationId] scheduled at [slotAt] (null for as-needed
  /// doses), kept current while the sheet is open.

  DoseDetailProvider call(String medicationId, DateTime? slotAt) =>
      DoseDetailProvider._(argument: (medicationId, slotAt), from: this);

  @override
  String toString() => r'doseDetailProvider';
}

/// Records what the current caregiver does with a dose. Each action
/// appends one event; nothing is edited in place. Kept alive so an undo
/// offered after the sheet closes still has a live notifier.

@ProviderFor(DoseActions)
final doseActionsProvider = DoseActionsProvider._();

/// Records what the current caregiver does with a dose. Each action
/// appends one event; nothing is edited in place. Kept alive so an undo
/// offered after the sheet closes still has a live notifier.
final class DoseActionsProvider extends $NotifierProvider<DoseActions, void> {
  /// Records what the current caregiver does with a dose. Each action
  /// appends one event; nothing is edited in place. Kept alive so an undo
  /// offered after the sheet closes still has a live notifier.
  DoseActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'doseActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$doseActionsHash();

  @$internal
  @override
  DoseActions create() => DoseActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$doseActionsHash() => r'3795f1844c47e51d8935e83a19a6dfec874b1408';

/// Records what the current caregiver does with a dose. Each action
/// appends one event; nothing is edited in place. Kept alive so an undo
/// offered after the sheet closes still has a live notifier.

abstract class _$DoseActions extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
