import 'package:hive_ce/hive.dart';
import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/core/utils/hive_guard.dart';
import 'package:i_care/features/care/data/mappers/care_event_codec.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';

/// This device's copy of the event log, as encoded events keyed by id.
/// Holds both synced events and the ones still waiting to be pushed.
class EventStore {
  const EventStore(this._box);

  final Box<String> _box;

  static String boxName(String deviceId) => 'care_events_$deviceId';

  /// Throws [StorageException] or [ParsingException].
  List<CareEvent> readAll() => [
    for (final value in hiveGuard('Event log', () => _box.values.toList()))
      CareEventCodec.decodeString(value),
  ];

  /// Events not yet received by the server.
  ///
  /// Throws [StorageException] or [ParsingException].
  List<CareEvent> readPending() => [
    for (final event in readAll())
      if (!event.meta.isSynced) event,
  ];

  /// Stores [events], replacing local copies with the same id. A synced
  /// copy is never replaced by an unsynced one, so a late local write
  /// cannot undo what the server confirmed.
  ///
  /// Throws [StorageException] or [ParsingException].
  Future<void> merge(Iterable<CareEvent> events) {
    final updates = <String, String>{};
    for (final event in events) {
      final stored = hiveGuard('Event log', () => _box.get(event.meta.id));
      final keepStored =
          stored != null &&
          !event.meta.isSynced &&
          CareEventCodec.decodeString(stored).meta.isSynced;
      if (!keepStored) {
        updates[event.meta.id] = CareEventCodec.encodeString(event);
      }
    }
    return hiveGuardAsync('Event log', () => _box.putAll(updates));
  }

  /// Drops events the server refused; they live on in the rejected store.
  ///
  /// Throws [StorageException].
  Future<void> remove(Iterable<String> ids) =>
      hiveGuardAsync('Event log', () => _box.deleteAll(ids));

  /// Fires after every change to the log.
  Stream<void> get changes => _box.watch();

  /// Throws [StorageException].
  Future<void> clear() => hiveGuardAsync('Event log', _box.clear);
}
