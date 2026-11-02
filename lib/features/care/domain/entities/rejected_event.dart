import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';

part 'rejected_event.freezed.dart';

/// Why the server refused an event (`docs/roles.md`).
enum RejectionReason {
  /// It names someone other than the member this device belongs to.
  wrongAuthor,

  /// The author's role does not allow it.
  notAllowed,

  /// The author is not a member any more, and it is not a fact.
  notMember,

  /// It would leave the circle without an admin.
  lastAdmin,
}

/// An event this device recorded and the server refused. Kept apart:
/// never sent again and left out of what the app shows, but listed so
/// nothing disappears silently.
@freezed
abstract class RejectedEvent with _$RejectedEvent {
  const factory RejectedEvent({
    required CareEvent event,
    required RejectionReason reason,
  }) = _RejectedEvent;
}
