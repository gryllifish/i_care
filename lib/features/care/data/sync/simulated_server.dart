import 'dart:async';
import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/core/utils/hive_guard.dart';
import 'package:i_care/features/care/data/mappers/care_event_codec.dart';

/// Stand-in for the backend in the demo: one shared, append-only log that
/// every simulated device syncs with.
///
/// It only exchanges encoded JSON, as a network would, so devices never
/// share Dart objects with it or with each other. Events are persisted in
/// Hive so the log survives reloads; each one gets a sequence number
/// (the cursor) and `receivedAt` from the server's clock.
class SimulatedServer {
  SimulatedServer(this._box, {required this._clock}) {
    for (final value in hiveGuard('Server log', () => _box.values.toList())) {
      final record = _Record.decode(value);
      _records.add(record);
      _byId[record.id] = record;
    }
    _records.sort((a, b) => a.sequence.compareTo(b.sequence));
  }

  static const boxName = 'simulated_server';

  final Box<String> _box;
  final DateTime Function() _clock;
  final _records = <_Record>[];
  final _byId = <String, _Record>{};
  final _appended = StreamController<void>.broadcast();

  int get _lastSequence => _records.isEmpty ? 0 : _records.last.sequence;

  /// Stores new events and returns every pushed event as stored.
  ///
  /// Throws [ParsingException] or [StorageException].
  Future<List<String>> receive(List<String> encodedEvents) async {
    final stored = <String>[];
    final added = <_Record>[];
    for (final encoded in encodedEvents) {
      final event = CareEventCodec.decodeString(encoded);
      final existing = _byId[event.meta.id];
      if (existing != null) {
        stored.add(existing.event);
        continue;
      }
      final record = _Record(
        sequence: _lastSequence + added.length + 1,
        id: event.meta.id,
        event: CareEventCodec.encodeString(
          event.copyWith(meta: event.meta.copyWith(receivedAt: _clock())),
        ),
      );
      added.add(record);
      _byId[record.id] = record;
      stored.add(record.event);
    }
    if (added.isEmpty) return stored;

    _records.addAll(added);
    await hiveGuardAsync(
      'Server log',
      () => _box.putAll({for (final r in added) r.id: r.encode()}),
    );
    _appended.add(null);
    return stored;
  }

  /// Encoded events after [cursor] in server order, and the cursor that
  /// follows them.
  ({List<String> events, String cursor}) eventsAfter(String? cursor) {
    final after = int.tryParse(cursor ?? '') ?? 0;
    return (
      events: [
        for (final record in _records)
          if (record.sequence > after) record.event,
      ],
      cursor: '$_lastSequence',
    );
  }

  /// Fires whenever new events are stored.
  Stream<void> get appended => _appended.stream;

  bool get isEmpty => _records.isEmpty;

  /// Throws [StorageException].
  Future<void> clear() async {
    _records.clear();
    _byId.clear();
    await hiveGuardAsync('Server log', _box.clear);
  }

  Future<void> dispose() => _appended.close();
}

class _Record {
  const _Record({
    required this.sequence,
    required this.id,
    required this.event,
  });

  /// Throws [ParsingException].
  factory _Record.decode(String value) {
    final Object? json;
    try {
      json = jsonDecode(value);
    } on FormatException catch (error) {
      throw ParsingException('Corrupted server record', cause: error);
    }
    if (json case {
      'seq': final int sequence,
      'id': final String id,
      'event': final String event,
    }) {
      return _Record(sequence: sequence, id: id, event: event);
    }
    throw const ParsingException('Corrupted server record');
  }

  final int sequence;
  final String id;

  /// The event as encoded by [CareEventCodec], with `receivedAt` set.
  final String event;

  String encode() => jsonEncode({'seq': sequence, 'id': id, 'event': event});
}
