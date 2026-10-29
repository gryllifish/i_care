import 'package:i_care/core/error/result.dart';
import 'package:i_care/features/care/controllers/care_recorder.dart';
import 'package:i_care/features/care/domain/entities/appointment.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/conflict.dart';
import 'package:i_care/shared/providers/id_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'appointment_actions.g.dart';

/// Changes to appointments, each carrying the version it was made on.
/// Callers validate first (`validateAppointment`).
@Riverpod(keepAlive: true)
class AppointmentActions extends _$AppointmentActions {
  @override
  void build() {}

  CareRecorder get _recorder => ref.read(careRecorderProvider);

  /// Adds an appointment and returns its id.
  Future<Result<String>> create(AppointmentDetails details) async {
    final id = ref.read(newIdProvider)();
    final result = await _recorder.record(
      CareEvent.appointmentCreated(
        meta: _recorder.meta(),
        appointmentId: id,
        details: details,
      ),
    );
    return switch (result) {
      Ok() => Ok(id),
      Err(:final failure) => Err(failure),
    };
  }

  Future<Result<void>> update(
    Appointment appointment,
    AppointmentDetails details,
  ) => _recorder.record(
    CareEvent.appointmentUpdated(
      meta: _recorder.meta(),
      appointmentId: appointment.id,
      baseVersion: appointment.version,
      details: details,
    ),
  );

  Future<Result<void>> cancel(Appointment appointment) => _recorder.record(
    CareEvent.appointmentCancelled(
      meta: _recorder.meta(),
      appointmentId: appointment.id,
      baseVersion: appointment.version,
    ),
  );

  /// Notes are appended, never edited, so they cannot conflict.
  Future<Result<void>> addNote(Appointment appointment, String text) =>
      _recorder.record(
        CareEvent.visitNoteAdded(
          meta: _recorder.meta(),
          appointmentId: appointment.id,
          text: text,
        ),
      );

  /// Settles [conflict] like medication edits: [chosen] is applied again
  /// unless it is the change in use, and the conflict is marked reviewed.
  Future<Result<void>> resolve(
    EditConflict conflict,
    Appointment appointment, {
    required CareEvent chosen,
  }) {
    final reapply = chosen == conflict.changes.last
        ? null
        : switch (chosen) {
            AppointmentUpdated(:final details) => CareEvent.appointmentUpdated(
              meta: _recorder.meta(),
              appointmentId: appointment.id,
              baseVersion: appointment.version,
              details: details,
            ),
            AppointmentCancelled() => CareEvent.appointmentCancelled(
              meta: _recorder.meta(),
              appointmentId: appointment.id,
              baseVersion: appointment.version,
            ),
            _ => null,
          };
    return _recorder.recordAll([
      ?reapply,
      CareEvent.conflictAcknowledged(
        meta: _recorder.meta(),
        conflictKey: conflict.key,
      ),
    ]);
  }
}
