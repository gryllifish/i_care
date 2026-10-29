/// Route paths. Features navigate with these constants so they never need
/// to import the router itself.
abstract final class AppRoutes {
  /// First tab: today's doses.
  static const today = '/';

  /// Second tab: every medication with its schedule and stock.
  static const medications = '/medications';

  /// Third tab: who did what, newest first.
  static const activity = '/activity';

  /// Nested under [medications], so the tab bar stays and back returns to
  /// the list.
  static const newMedication = 'new';
  static const medication = ':$medicationIdParam';
  static const medicationIdParam = 'id';

  /// Nested under [medication].
  static const editMedication = 'edit';
  static const changeSchedule = 'schedule';

  static String newMedicationPath() => '$medications/$newMedication';

  static String medicationPath(String id) => '$medications/$id';

  static String editMedicationPath(String id) =>
      '${medicationPath(id)}/$editMedication';

  static String changeSchedulePath(String id) =>
      '${medicationPath(id)}/$changeSchedule';
}
