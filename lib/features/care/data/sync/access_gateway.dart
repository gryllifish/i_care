import 'package:i_care/core/error/app_exception.dart';

/// A Google account as Google's sign-in hands it over: the tokens the
/// server checks, and the address shown to the person.
typedef GoogleCredential = ({
  String idToken,
  String? accessToken,
  String email,
});

/// Protecting this device's access with a Google account, and getting it
/// back on a new phone (`docs/roles.md`, recoverable access). The
/// simulated server answers it for tests; Supabase Auth and the
/// backend's functions do in the beta.
abstract interface class AccessGateway {
  /// The email of the Google account protecting this device's access;
  /// null when none does.
  Future<String?> protectedWith();

  /// Links [credential] to this device's access and returns its email.
  ///
  /// Throws [NoConnectionException], [NotMemberException] or
  /// [AccountInUseException].
  Future<String> protect(GoogleCredential credential);

  /// Makes this device the member whose access [credential] protects,
  /// ending that access on every other device; returns the member's id.
  ///
  /// Throws [NoConnectionException] or [NoAccessException].
  Future<String> recover(GoogleCredential credential);
}
