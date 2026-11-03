import 'package:hive_ce/hive.dart';
import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/core/utils/hive_guard.dart';

/// Where this device left off syncing: the server cursor and when it last
/// heard from the server.
class SyncStateStore {
  const SyncStateStore(this._box);

  final Box<String> _box;

  static String boxName(String deviceId) => 'sync_state_$deviceId';

  static const _cursorKey = 'cursor';
  static const _lastSyncedAtKey = 'last_synced_at';

  /// Throws [StorageException].
  String? get cursor => hiveGuard('Sync state', () => _box.get(_cursorKey));

  /// Throws [StorageException].
  DateTime? get lastSyncedAt =>
      switch (hiveGuard('Sync state', () => _box.get(_lastSyncedAtKey))) {
        final String value => DateTime.tryParse(value),
        null => null,
      };

  /// Throws [StorageException].
  Future<void> save({required DateTime lastSyncedAt, String? cursor}) =>
      hiveGuardAsync(
        'Sync state',
        () => _box.putAll({
          _cursorKey: ?cursor,
          _lastSyncedAtKey: lastSyncedAt.toIso8601String(),
        }),
      );

  /// Throws [StorageException].
  Future<void> clear() => hiveGuardAsync('Sync state', _box.clear);
}
