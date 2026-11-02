// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_actions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Changes to appointments, each carrying the version it was made on.
/// Callers validate first (`validateAppointment`).

@ProviderFor(AppointmentActions)
final appointmentActionsProvider = AppointmentActionsProvider._();

/// Changes to appointments, each carrying the version it was made on.
/// Callers validate first (`validateAppointment`).
final class AppointmentActionsProvider
    extends $NotifierProvider<AppointmentActions, void> {
  /// Changes to appointments, each carrying the version it was made on.
  /// Callers validate first (`validateAppointment`).
  AppointmentActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appointmentActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appointmentActionsHash();

  @$internal
  @override
  AppointmentActions create() => AppointmentActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$appointmentActionsHash() =>
    r'1a15164d6a589184c331a1a6899d0cc5ffcf5f57';

/// Changes to appointments, each carrying the version it was made on.
/// Callers validate first (`validateAppointment`).

abstract class _$AppointmentActions extends $Notifier<void> {
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
