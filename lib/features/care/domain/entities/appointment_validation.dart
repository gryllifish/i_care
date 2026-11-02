import 'package:i_care/features/care/domain/entities/appointment.dart';

/// Something to fix before an appointment can be saved.
enum AppointmentIssue { titleMissing }

/// Issues in [details]; empty when they can be saved.
Set<AppointmentIssue> validateAppointment(AppointmentDetails details) => {
  if (details.title.trim().isEmpty) AppointmentIssue.titleMissing,
};

/// Something to fix before a document link can be saved.
enum DocumentIssue { titleMissing, urlInvalid }

/// [text] as an http or https URL, adding `https://` when no scheme was
/// typed ("lab.example.com/results"); null when it is not a web address.
String? parseDocumentUrl(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty || trimmed.contains(' ')) return null;
  final hasScheme = trimmed.contains('://');
  // "mailto:…" or "javascript:…" typed without "//" is another scheme,
  // not a host; a host's port ("lab.example.com:8080") is digits.
  if (!hasScheme && _otherScheme.hasMatch(trimmed)) return null;
  final uri = Uri.tryParse(hasScheme ? trimmed : 'https://$trimmed');
  if (uri == null ||
      !(uri.scheme == 'http' || uri.scheme == 'https') ||
      !uri.host.contains('.') ||
      // "https://trusted.example.com@other.example" hides its real host.
      uri.userInfo.isNotEmpty) {
    return null;
  }
  return uri.toString();
}

final _otherScheme = RegExp(r'^[a-zA-Z][a-zA-Z0-9+.-]*:(?!\d)');

/// Issues in a document link being added; empty when it can be saved.
Set<DocumentIssue> validateDocument({
  required String title,
  required String url,
}) => {
  if (title.trim().isEmpty) DocumentIssue.titleMissing,
  if (parseDocumentUrl(url) == null) DocumentIssue.urlInvalid,
};
