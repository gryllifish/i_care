import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/core/utils/hive_guard.dart';
import 'package:i_care/features/care/data/mappers/care_event_codec.dart';
import 'package:i_care/features/care/domain/entities/rejected_event.dart';

/// Events this device recorded and the server refused, keyed by id. Kept
/// apart from the log so they are never sent again nor shown as if they
/// had happened, until someone dismisses them.
class RejectedStore {
  const RejectedStore(this._box);

  final Box<String> _box;

  static String boxName(String deviceId) => 'care_rejected_$deviceId';

  /// Oldest first.
  ///
  /// Throws [StorageException] or [ParsingException].
  List<RejectedEvent> readAll() {
    final rejected = [
      for (final value in hiveGuard('Rejected', () => _box.values.toList()))
        _decode(value),
    ];
    return rejected..sort(
      (a, b) => a.event.meta.occurredAt.compareTo(b.event.meta.occurredAt),
    );
  }

  /// Throws [StorageException].
  Future<void> add(Iterable<RejectedEvent> rejected) => hiveGuardAsync(
    'Rejected',
    () => _box.putAll({
      for (final item in rejected)
        item.event.meta.id: jsonEncode({
          'event': CareEventCodec.encode(item.event),
          'reason': item.reason.name,
        }),
    }),
  );

  /// Throws [StorageException].
  Future<void> remove(String eventId) =>
      hiveGuardAsync('Rejected', () => _box.delete(eventId));

  /// Fires after every change.
  Stream<void> get changes => _box.watch();

  /// Throws [StorageException].
  Future<void> clear() => hiveGuardAsync('Rejected', _box.clear);

  /// Throws [ParsingException].
  static RejectedEvent _decode(String value) {
    final Object? json;
    try {
      json = jsonDecode(value);
    } on FormatException catch (error) {
      throw ParsingException('Corrupted rejected event', cause: error);
    }
    if (json case {
      'event': final Map<String, Object?> event,
      'reason': final String reason,
    }) {
      final known = RejectionReason.values.asNameMap()[reason];
      if (known != null) {
        return RejectedEvent(
          event: CareEventCodec.decode(event),
          reason: known,
        );
      }
    }
    throw const ParsingException('Corrupted rejected event');
  }
}
