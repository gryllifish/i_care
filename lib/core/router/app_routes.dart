/// Route paths. Features navigate with these constants so they never need
/// to import the router itself.
abstract final class AppRoutes {
  /// First tab: today's doses.
  static const today = '/';

  /// Second tab: every medication with its schedule and stock.
  static const medications = '/medications';

  /// Third tab: care tasks that are not medications.
  static const tasks = '/tasks';

  /// Fourth tab: medical appointments and visit notes.
  static const appointments = '/appointments';

  /// Fifth tab: who did what, newest first.
  static const activity = '/activity';

  /// Nested under [medications], so the tab bar stays and back returns to
  /// the list.
  static const newMedication = 'new';
  static const medication = ':$idParam';

  /// The id in medication, task and appointment paths.
  static const idParam = 'id';

  /// Nested under [medication].
  static const editMedication = 'edit';
  static const changeSchedule = 'schedule';

  static String newMedicationPath() => '$medications/$newMedication';

  static String medicationPath(String id) => '$medications/$id';

  static String editMedicationPath(String id) =>
      '${medicationPath(id)}/$editMedication';

  static String changeSchedulePath(String id) =>
      '${medicationPath(id)}/$changeSchedule';

  /// Full screen, over the tabs: reachable from Today in one tap.
  static const emergency = '/emergency';
  static const editEmergency = 'edit';

  static String editEmergencyPath() => '$emergency/$editEmergency';

  /// Full screen too: the handoff text and a copy button.
  static const handoff = '/handoff';

  static const settings = '/settings';

  /// Shown instead of everything else until the welcome was seen.
  static const welcome = '/welcome';

  /// Nested under [appointments], like medications.
  static const newAppointment = 'new';
  static const appointment = ':$idParam';
  static const editAppointment = 'edit';

  static String newAppointmentPath() => '$appointments/$newAppointment';

  static String appointmentPath(String id) => '$appointments/$id';

  static String editAppointmentPath(String id) =>
      '${appointmentPath(id)}/$editAppointment';

  /// Nested under [tasks]; a task opens straight into its form.
  static const newTask = 'new';
  static const editTask = ':$idParam';

  static String newTaskPath() => '$tasks/$newTask';

  static String editTaskPath(String id) => '$tasks/$id';
}
