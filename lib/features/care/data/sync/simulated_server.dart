import 'dart:async';
import 'dart:convert';

import 'package:hive_ce/hive.dart';
import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/core/utils/hive_guard.dart';
import 'package:i_care/features/care/data/mappers/care_event_codec.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/features/care/domain/entities/rejected_event.dart';
import 'package:i_care/features/care/domain/permissions.dart';

/// What the server answers to a push: events stored (encoded, with
/// `receivedAt`) and the ids it refused with why.
typedef ServerPushResult = ({
  List<String> stored,
  List<({String id, RejectionReason reason})> rejected,
});

/// Stand-in for the backend in the demo: one shared, append-only log that
/// every simulated device syncs with, and the server-side state a real
/// backend keeps apart from it (`docs/roles.md`): members and their roles,
/// and which member each device belongs to.
///
/// It only exchanges encoded JSON, as a network would, so devices never
/// share Dart objects with it or with each other. Events and device
/// bindings are persisted in Hive so they survive reloads; each event
/// gets a sequence number (the cursor) and `receivedAt` from the server's
/// clock. Members are recomputed from the stored log on start: here the
/// log is the server's own record; Firestore keeps them as documents.
class SimulatedServer {
  SimulatedServer(this._box, this._devices, {required this._clock}) {
    for (final value in hiveGuard('Server log', () => _box.values.toList())) {
      final record = _Record.decode(value);
      _records.add(record);
      _byId[record.id] = record;
    }
    _records.sort((a, b) => a.sequence.compareTo(b.sequence));
    for (final record in _records) {
      _remember(CareEventCodec.decodeString(record.event));
    }
    for (final MapEntry(:key, :value) in hiveGuard(
      'Server devices',
      () => _devices.toMap().cast<String, String>(),
    ).entries) {
      _bindings[key] = _Binding.decode(value);
    }
  }

  static const boxName = 'simulated_server';
  static const devicesBoxName = 'simulated_server_devices';

  final Box<String> _box;
  final Box<String> _devices;
  final DateTime Function() _clock;
  final _records = <_Record>[];
  final _byId = <String, _Record>{};
  final _appended = StreamController<void>.broadcast();

  final _members = <String, ({MemberRole role, bool removed})>{};
  final _authors = <String, String>{};
  final _bindings = <String, _Binding>{};

  int get _lastSequence => _records.isEmpty ? 0 : _records.last.sequence;

  /// Whether the log has any member: logs from before roles have none.
  bool get hasMembers => _members.isNotEmpty;

  /// Checks and stores [encodedEvents] pushed by [deviceId], in order, so
  /// each event is checked against the state the ones before it left.
  ///
  /// Throws [ParsingException] or [StorageException].
  Future<ServerPushResult> receive(
    String deviceId,
    List<String> encodedEvents,
  ) async {
    final stored = <String>[];
    final rejected = <({String id, RejectionReason reason})>[];
    final added = <_Record>[];
    for (final encoded in encodedEvents) {
      final event = CareEventCodec.decodeString(encoded);
      if (_byId[event.meta.id] case final existing?) {
        stored.add(existing.event);
        continue;
      }
      switch (_check(deviceId, event)) {
        case _Verdict(:final reason?):
          rejected.add((id: event.meta.id, reason: reason));
        case _Verdict(:final fromFormerMember):
          final record = _store(
            event,
            sequence: _lastSequence + added.length + 1,
            fromFormerMember: fromFormerMember,
          );
          added.add(record);
          stored.add(record.event);
      }
    }
    await _persist(added);
    return (stored: stored, rejected: rejected);
  }

  /// Stores [encodedEvents] without checks, as the circle's history: the
  /// sample data, as if it had been recorded before.
  ///
  /// Throws [ParsingException] or [StorageException].
  Future<void> seed(List<String> encodedEvents) async {
    final added = <_Record>[];
    for (final encoded in encodedEvents) {
      final event = CareEventCodec.decodeString(encoded);
      if (_byId.containsKey(event.meta.id)) continue;
      added.add(_store(event, sequence: _lastSequence + added.length + 1));
    }
    await _persist(added);
  }

  /// Binds [deviceId] to [memberId]: what joining with a code does.
  ///
  /// Throws [StorageException].
  Future<void> bind(String deviceId, String memberId) {
    final binding = _Binding(memberId: memberId);
    _bindings[deviceId] = binding;
    return hiveGuardAsync(
      'Server devices',
      () => _devices.put(deviceId, binding.encode()),
    );
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
    _members.clear();
    _authors.clear();
    _bindings.clear();
    await hiveGuardAsync('Server log', _box.clear);
    await hiveGuardAsync('Server devices', _devices.clear);
  }

  Future<void> dispose() => _appended.close();

  /// Whether [deviceId] may add [event] (`docs/roles.md`, "Checking each
  /// event").
  _Verdict _check(String deviceId, CareEvent event) {
    final binding = _bindings[deviceId];
    if (binding == null) {
      return const _Verdict.reject(RejectionReason.notMember);
    }

    final author = event.meta.caregiverId;
    if (author != binding.memberId) {
      return const _Verdict.reject(RejectionReason.wrongAuthor);
    }
    final action = actionOf(
      event,
      authorId: author,
      targetAuthorId: switch (event) {
        DoseUndone(:final targetEventId) => _authors[targetEventId],
        _ => null,
      },
    );
    if (action == null) {
      return const _Verdict.reject(RejectionReason.notAllowed);
    }

    final member = _members[author];
    final isCurrent = member != null && !member.removed && !binding.ended;
    if (!isCurrent) {
      return isFact(action)
          ? const _Verdict.accept(fromFormerMember: true)
          : const _Verdict.reject(RejectionReason.notMember);
    }
    if (!can(member.role, action)) {
      return const _Verdict.reject(RejectionReason.notAllowed);
    }
    if (_leavesNoAdmin(event)) {
      return const _Verdict.reject(RejectionReason.lastAdmin);
    }
    return const _Verdict.accept();
  }

  /// Whether [event] would take away the circle's last admin.
  bool _leavesNoAdmin(CareEvent event) {
    final memberId = switch (event) {
      RoleChanged(:final memberId, :final role) when role != MemberRole.admin =>
        memberId,
      MemberRemoved(:final memberId) ||
      InvitationRevoked(:final memberId) => memberId,
      _ => null,
    };
    if (memberId == null || _members[memberId]?.role != MemberRole.admin) {
      return false;
    }
    final admins = _members.values.where(
      (member) => member.role == MemberRole.admin && !member.removed,
    );
    return admins.length <= 1;
  }

  _Record _store(
    CareEvent event, {
    required int sequence,
    bool fromFormerMember = false,
  }) {
    final storedEvent = event.copyWith(
      meta: event.meta.copyWith(
        receivedAt: _clock(),
        fromFormerMember: fromFormerMember,
      ),
    );
    _remember(storedEvent);
    final record = _Record(
      sequence: sequence,
      id: event.meta.id,
      event: CareEventCodec.encodeString(storedEvent),
    );
    _byId[record.id] = record;
    return record;
  }

  Future<void> _persist(List<_Record> added) async {
    if (added.isEmpty) return;
    _records.addAll(added);
    await hiveGuardAsync(
      'Server log',
      () => _box.putAll({for (final r in added) r.id: r.encode()}),
    );
    await hiveGuardAsync(
      'Server devices',
      () => _devices.putAll({
        for (final MapEntry(:key, :value) in _bindings.entries)
          key: value.encode(),
      }),
    );
    _appended.add(null);
  }

  /// Updates members and authors with a stored event.
  void _remember(CareEvent event) {
    _authors[event.meta.id] = event.meta.caregiverId;
    switch (event) {
      case MemberInvited(:final memberId, :final role)
          when !_members.containsKey(memberId):
        _members[memberId] = (role: role, removed: false);
      case RoleChanged(:final memberId, :final role):
        if (_members[memberId] case final member?) {
          _members[memberId] = (role: role, removed: member.removed);
        }
      case MemberRemoved(:final memberId) || InvitationRevoked(:final memberId):
        if (_members[memberId] case final member?) {
          _members[memberId] = (role: member.role, removed: true);
        }
        _endBindings(memberId);
      case _:
        break;
    }
  }

  /// Bindings end, never disappear: the server still knows who wrote a
  /// late record from a removed member's device. Saved with the events
  /// that ended them.
  void _endBindings(String memberId) {
    for (final deviceId in _bindings.keys.toList()) {
      if (_bindings[deviceId] case _Binding(
        memberId: final bound,
        ended: false,
      ) when bound == memberId) {
        _bindings[deviceId] = _Binding(memberId: memberId, ended: true);
      }
    }
  }
}

/// The outcome of checking one event.
class _Verdict {
  const _Verdict.accept({this.fromFormerMember = false}) : reason = null;
  const _Verdict.reject(RejectionReason this.reason) : fromFormerMember = false;

  final RejectionReason? reason;
  final bool fromFormerMember;
}

/// Which member a device belongs to, and whether that has ended.
class _Binding {
  const _Binding({required this.memberId, this.ended = false});

  /// Throws [ParsingException].
  factory _Binding.decode(String value) {
    final Object? json;
    try {
      json = jsonDecode(value);
    } on FormatException catch (error) {
      throw ParsingException('Corrupted device binding', cause: error);
    }
    if (json case {'member': final String memberId, 'ended': final bool e}) {
      return _Binding(memberId: memberId, ended: e);
    }
    throw const ParsingException('Corrupted device binding');
  }

  final String memberId;
  final bool ended;

  String encode() => jsonEncode({'member': memberId, 'ended': ended});
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
