import 'package:i_care/core/error/failure.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/rejected_event.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';

/// The care circle's event log on this device, kept in sync with the
/// other caregivers' devices in the background.
abstract interface class CareRepository {
  /// The whole log, now and after every change. Errors arrive as
  /// [Failure]s on the stream.
  Stream<List<CareEvent>> watchEvents();

  /// Appends [event] to the log on this device and syncs it in the
  /// background. Fails only if it could not be stored here; being offline
  /// is not a failure.
  Future<Result<void>> record(CareEvent event);

  /// Reconnects to the server and sends what is pending, for someone who
  /// asks to be up to date now. Being offline is not a failure: the sync
  /// state says so.
  Future<Result<void>> syncNow();

  /// The sync state, now and after every change.
  Stream<SyncStatus> watchSyncStatus();

  /// Events recorded here that the server refused, now and after every
  /// change. They are not part of [watchEvents].
  Stream<List<RejectedEvent>> watchRejected();

  /// Stops listing a refused event once someone has read about it.
  Future<Result<void>> dismissRejected(String eventId);
}
