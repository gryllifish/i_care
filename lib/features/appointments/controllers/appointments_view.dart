import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:i_care/features/care/controllers/care_controllers.dart';
import 'package:i_care/features/care/domain/entities/appointment.dart';
import 'package:i_care/features/care/domain/entities/conflict.dart';
import 'package:i_care/features/care/domain/projections/care_log.dart';
import 'package:i_care/shared/providers/now_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'appointments_view.freezed.dart';
part 'appointments_view.g.dart';

/// How long after its start an appointment still counts as upcoming, so
/// it stays on top while people are at the doctor's.
const appointmentGrace = Duration(hours: 2);

/// How recent a past appointment must be to still ask for notes.
const notesPromptWindow = Duration(days: 14);

/// Everything the appointments tab shows.
@freezed
abstract class AppointmentsView with _$AppointmentsView {
  const factory AppointmentsView({
    /// Soonest first.
    @Default(<Appointment>[]) List<Appointment> upcoming,

    /// Most recent first.
    @Default(<Appointment>[]) List<Appointment> past,

    /// Ids of recent past appointments nobody wrote notes for.
    @Default(<String>{}) Set<String> missingNotes,

    /// Ids of appointments with concurrent edits to review.
    @Default(<String>{}) Set<String> needReview,
  }) = _AppointmentsView;
}

AppointmentsView buildAppointmentsView(CareLog log, DateTime now) {
  final upcoming = <Appointment>[];
  final past = <Appointment>[];
  for (final appointment in log.appointments) {
    (appointment.startsAt.add(appointmentGrace).isAfter(now) ? upcoming : past)
        .add(appointment);
  }
  return AppointmentsView(
    upcoming: upcoming,
    past: past.reversed.toList(),
    missingNotes: {
      for (final appointment in past)
        if (appointment.notes.isEmpty &&
            now.difference(appointment.startsAt) < notesPromptWindow)
          appointment.id,
    },
    needReview: {
      for (final conflict in log.conflicts.whereType<EditConflict>())
        if (log.appointment(conflict.entityId) != null) conflict.entityId,
    },
  );
}

@riverpod
AsyncValue<AppointmentsView> appointmentsView(Ref ref) {
  final now = ref.watch(nowProvider);
  return ref
      .watch(careLogProvider)
      .whenData((log) => buildAppointmentsView(log, now));
}

/// An appointment, cancelled or not, with its unreviewed edits.
typedef AppointmentDetail = ({
  Appointment appointment,
  List<EditConflict> conflicts,
});

@riverpod
AsyncValue<AppointmentDetail?> appointmentDetail(
  Ref ref,
  String appointmentId,
) => ref.watch(careLogProvider).whenData((log) {
  final appointment = log.appointment(appointmentId);
  if (appointment == null) return null;
  return (
    appointment: appointment,
    conflicts: [
      for (final conflict in log.conflicts.whereType<EditConflict>())
        if (conflict.entityId == appointmentId) conflict,
    ],
  );
});
