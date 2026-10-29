// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointments_view.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appointmentsView)
final appointmentsViewProvider = AppointmentsViewProvider._();

final class AppointmentsViewProvider
    extends
        $FunctionalProvider<
          AsyncValue<AppointmentsView>,
          AsyncValue<AppointmentsView>,
          AsyncValue<AppointmentsView>
        >
    with $Provider<AsyncValue<AppointmentsView>> {
  AppointmentsViewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appointmentsViewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appointmentsViewHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<AppointmentsView>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<AppointmentsView> create(Ref ref) {
    return appointmentsView(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<AppointmentsView> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<AppointmentsView>>(value),
    );
  }
}

String _$appointmentsViewHash() => r'7ca54e44790c696df9e8a859b2fe0bd661796c14';

@ProviderFor(appointmentDetail)
final appointmentDetailProvider = AppointmentDetailFamily._();

final class AppointmentDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<AppointmentDetail?>,
          AsyncValue<AppointmentDetail?>,
          AsyncValue<AppointmentDetail?>
        >
    with $Provider<AsyncValue<AppointmentDetail?>> {
  AppointmentDetailProvider._({
    required AppointmentDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'appointmentDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$appointmentDetailHash();

  @override
  String toString() {
    return r'appointmentDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<AsyncValue<AppointmentDetail?>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<AppointmentDetail?> create(Ref ref) {
    final argument = this.argument as String;
    return appointmentDetail(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<AppointmentDetail?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<AppointmentDetail?>>(
        value,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AppointmentDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$appointmentDetailHash() => r'41f0e78699b6771076a4575e8fe28f3b0d3e2547';

final class AppointmentDetailFamily extends $Family
    with $FunctionalFamilyOverride<AsyncValue<AppointmentDetail?>, String> {
  AppointmentDetailFamily._()
    : super(
        retry: null,
        name: r'appointmentDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AppointmentDetailProvider call(String appointmentId) =>
      AppointmentDetailProvider._(argument: appointmentId, from: this);

  @override
  String toString() => r'appointmentDetailProvider';
}
