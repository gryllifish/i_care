import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';

/// Events the server has, after a cursor, and the cursor to resume from.
typedef SyncBatch = ({List<CareEvent> events, String cursor});

/// The device's link to the shared log on a server. The simulated remote
/// implements it today and Firestore will later (`docs/backend.md`);
/// nothing outside `data` knows which one runs.
abstract interface class SyncGateway {
  /// Uploads [events] and returns them as the server stored them, with
  /// `receivedAt` set. Idempotent by event id: an event the server already
  /// has comes back as stored, unchanged.
  ///
  /// Throws [NoConnectionException] when offline.
  Future<List<CareEvent>> push(List<CareEvent> events);

  /// Every event received after [cursor] (all of them when null), then
  /// new ones as they arrive, in server order. While offline the stream
  /// emits a [NoConnectionException] and stays open; it resumes with
  /// whatever was missed once the connection is back.
  Stream<SyncBatch> watch({String? cursor});
}
