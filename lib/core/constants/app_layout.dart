/// How screens adapt to their width. The app is designed for phones; on
/// wider screens (the web on a computer, tablets) it keeps the same
/// design in a readable column, with navigation at the side.
abstract final class AppLayout {
  /// The widest content gets: forms, lists and cards stay readable.
  static const contentMaxWidth = 720.0;

  /// From this width the tabs move from the bottom to a side rail
  /// (Material's "expanded" window class).
  static const sideNavigationMinWidth = 840.0;

  /// The widest a bottom sheet gets.
  static const sheetMaxWidth = 640.0;
}
