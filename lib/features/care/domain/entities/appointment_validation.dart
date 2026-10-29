import 'package:i_care/features/care/domain/entities/appointment.dart';

/// Something to fix before an appointment can be saved.
enum AppointmentIssue { titleMissing }

/// Issues in [details]; empty when they can be saved.
Set<AppointmentIssue> validateAppointment(AppointmentDetails details) => {
  if (details.title.trim().isEmpty) AppointmentIssue.titleMissing,
};
