import 'package:i_care/core/error/result.dart';

/// Protecting this phone's access with a Google account, so its member
/// can get back in on a new phone without anyone issuing a code
/// (`docs/roles.md`, recoverable access).
abstract interface class AccessRepository {
  /// The email of the Google account protecting this phone's access;
  /// null when none does.
  Future<Result<String?>> protectedWith();

  /// Asks for a Google account and protects this phone's access with it;
  /// returns its email, or null when the person closed the picker. Needs
  /// a connection.
  Future<Result<String?>> protect();

  /// Asks for a Google account and makes this phone the member whose
  /// access it protects; returns the member's id, or null when the person
  /// closed the picker. Every other phone of that member loses its
  /// access, and the circle is told. Starts this phone's copy of the log
  /// over. Needs a connection.
  Future<Result<String?>> recover();
}
