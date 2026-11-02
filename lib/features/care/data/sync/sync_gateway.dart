import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/rejected_event.dart';

/// Events the server has, after a cursor, and the cursor to resume from.
typedef SyncBatch = ({List<CareEvent> events, String cursor});

/// What the server did with each pushed event: one refused event never
/// holds back the others.
typedef PushResult = ({List<CareEvent> stored, List<RejectedEvent> rejected});

/// The device's link to the shared log on a server. The simulated remote
/// implements it today and Firestore will later (`docs/backend.md`);
/// nothing outside `data` knows which one runs.
///
/// Every device belongs to one member, and the server checks each event
/// against that member's role (`docs/roles.md`).
abstract interface class SyncGateway {
  /// Uploads [events]. Returns the ones stored, as the server stored them
  /// (`receivedAt` set; `fromFormerMember` when a former member's fact),
  /// and the ones refused with why. Idempotent by event id: an event the
  /// server already has comes back as stored, unchanged.
  ///
  /// Throws [NoConnectionException] when offline.
  Future<PushResult> push(List<CareEvent> events);

  /// Every event received after [cursor] (all of them when null), then
  /// new ones as they arrive, in server order. While offline the stream
  /// emits a [NoConnectionException] and stays open; it resumes with
  /// whatever was missed once the connection is back.
  Stream<SyncBatch> watch({String? cursor});
}
