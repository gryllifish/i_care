/// Route paths. Features navigate with these constants so they never need
/// to import the router itself.
abstract final class AppRoutes {
  /// First tab: today's doses.
  static const today = '/';

  /// Second tab: every medication with its schedule and stock.
  static const medications = '/medications';

  /// Third tab: who did what, newest first.
  static const activity = '/activity';
}
