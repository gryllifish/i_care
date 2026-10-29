import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_status.freezed.dart';

/// How up to date this device is with the rest of the circle.
@freezed
abstract class SyncStatus with _$SyncStatus {
  const factory SyncStatus({
    /// Last time the server confirmed this device was up to date; null if
    /// it never synced.
    DateTime? lastSyncedAt,

    /// Events recorded here that the server has not received yet.
    @Default(0) int pendingCount,
    @Default(true) bool isConnected,
  }) = _SyncStatus;
}
