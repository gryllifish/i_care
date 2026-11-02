// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dose_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The dose of [medicationId] scheduled at [slotAt] (null for as-needed
/// doses), kept current while the sheet is open. Warnings are for
/// recording it as given at [givenAt], or now when null.

@ProviderFor(doseDetail)
final doseDetailProvider = DoseDetailFamily._();

/// The dose of [medicationId] scheduled at [slotAt] (null for as-needed
/// doses), kept current while the sheet is open. Warnings are for
/// recording it as given at [givenAt], or now when null.

final class DoseDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<DoseDetail?>,
          AsyncValue<DoseDetail?>,
          AsyncValue<DoseDetail?>
        >
    with $Provider<AsyncValue<DoseDetail?>> {
  /// The dose of [medicationId] scheduled at [slotAt] (null for as-needed
  /// doses), kept current while the sheet is open. Warnings are for
  /// recording it as given at [givenAt], or now when null.
  DoseDetailProvider._({
    required DoseDetailFamily super.from,
    required (String, DateTime?, {DateTime? givenAt}) super.argument,
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
    final argument = this.argument as (String, DateTime?, {DateTime? givenAt});
    return doseDetail(ref, argument.$1, argument.$2, givenAt: argument.givenAt);
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

String _$doseDetailHash() => r'9f0de64530ae124959cc10bc3000dadad5a9b9ca';

/// The dose of [medicationId] scheduled at [slotAt] (null for as-needed
/// doses), kept current while the sheet is open. Warnings are for
/// recording it as given at [givenAt], or now when null.

final class DoseDetailFamily extends $Family
    with
        $FunctionalFamilyOverride<
          AsyncValue<DoseDetail?>,
          (String, DateTime?, {DateTime? givenAt})
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
  /// doses), kept current while the sheet is open. Warnings are for
  /// recording it as given at [givenAt], or now when null.

  DoseDetailProvider call(
    String medicationId,
    DateTime? slotAt, {
    DateTime? givenAt,
  }) => DoseDetailProvider._(
    argument: (medicationId, slotAt, givenAt: givenAt),
    from: this,
  );

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

String _$doseActionsHash() => r'dfb42c640537167d97b36c4faddb7e0fd6ca691c';

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
