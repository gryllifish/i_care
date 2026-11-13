import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:hive_ce/hive.dart';
import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/core/error/failure.dart';
import 'package:i_care/core/utils/hive_guard.dart';
import 'package:i_care/features/care/data/mappers/care_event_codec.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/features/care/domain/entities/rejected_event.dart';
import 'package:i_care/features/care/domain/permissions.dart';

/// A one-time invitation code and until when it can be used, by the
/// server's clock.
typedef IssuedCode = ({String code, DateTime expiresAt});

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
/// log is the server's own record; Supabase keeps them as tables.
class SimulatedServer {
  SimulatedServer(
    this._box,
    this._devices,
    this._codes,
    this._settings, {
    required this._clock,
    Random? random,
  }) : _random = random ?? Random.secure() {
    for (final value in hiveGuard('Server log', () => _box.values.toList())) {
      _records.add(_Record.decode(value));
    }
    _records.sort((a, b) => a.sequence.compareTo(b.sequence));
    for (final (index, record) in _records.indexed) {
      var event = CareEventCodec.decodeString(record.event);
      // Logs stored before events carried their place get it here.
      if (event.meta.serverSeq == null) {
        event = event.copyWith(
          meta: event.meta.copyWith(serverSeq: record.sequence),
        );
        _records[index] = record.withEvent(CareEventCodec.encodeString(event));
      }
      _byId[record.id] = _records[index];
      _remember(event);
      _lastReceivedAt = event.meta.receivedAt ?? _lastReceivedAt;
    }
    for (final MapEntry(:key, :value) in hiveGuard(
      'Server devices',
      () => _devices.toMap().cast<String, String>(),
    ).entries) {
      _bindings[key] = _Binding.decode(value);
    }
    for (final MapEntry(:key, :value) in hiveGuard(
      'Server codes',
      () => _codes.toMap().cast<String, String>(),
    ).entries) {
      _issued[key] = _Code.decode(value);
    }
  }

  static const boxName = 'simulated_server';
  static const devicesBoxName = 'simulated_server_devices';
  static const codesBoxName = 'simulated_server_codes';
  static const settingsBoxName = 'simulated_server_settings';
  static const _startedEmptyKey = 'started_empty';

  /// How long an invitation code can be used (`docs/roles.md`).
  static const codeLifetime = Duration(hours: 48);

  /// Letters and digits that cannot be misread for one another: no 0/O,
  /// 1/I/L.
  static const _codeAlphabet = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
  static const _codeHalf = 3;

  final Box<String> _box;
  final Box<String> _devices;

  /// Invitation codes: a secret the log never holds.
  final Box<String> _codes;

  /// The demo's own switches, such as having started without data.
  final Box<String> _settings;
  final DateTime Function() _clock;
  final Random _random;
  final _records = <_Record>[];
  final _byId = <String, _Record>{};
  final _appended = StreamController<void>.broadcast();

  final _members = <String, ({MemberRole role, bool removed})>{};
  final _authors = <String, String>{};
  final _audiences = <String, Audience>{};

  /// The latest `receivedAt` given, so the next one is always later
  /// where the platform keeps microseconds; `serverSeq` orders the log.
  DateTime? _lastReceivedAt;
  final _bindings = <String, _Binding>{};

  /// Which device each protected access belongs to, by its Google
  /// account's email (`docs/roles.md`, recoverable access). Kept in
  /// memory: the demo does not offer it; tests and the contract do.
  final _accounts = <String, String>{};
  final _issued = <String, _Code>{};

  int get _lastSequence => _records.isEmpty ? 0 : _records.last.sequence;

  /// Whether the log has any member: logs from before roles have none.
  bool get hasMembers => _members.isNotEmpty;

  /// Whether the log says how the circle began: logs from before circles
  /// recorded it do not.
  bool get hasCircle => _hasCircle;
  var _hasCircle = false;

  /// Whether the demo was asked to start without data, so an empty log
  /// is not filled with the sample on the next start.
  bool get startedEmpty =>
      hiveGuard('Server settings', () => _settings.get(_startedEmptyKey)) ==
      'true';

  /// Whether [memberId] belongs to the circle now.
  bool hasMember(String memberId) => _members[memberId]?.removed == false;

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
          // A device leaving unbinds only itself.
          if (event is MemberLeft) {
            _bindings[deviceId] = _Binding(
              memberId: event.memberId,
              ended: true,
            );
            _unprotect(deviceId);
          }
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

  /// Whether [deviceId] belongs to a current member: what lets it read
  /// the log.
  bool isActive(String deviceId) => switch (_bindings[deviceId]) {
    _Binding(:final memberId, ended: false) =>
      _members[memberId]?.removed == false,
    _ => false,
  };

  /// Whether [deviceId] ever joined, even if it left since.
  bool knowsDevice(String deviceId) => _bindings.containsKey(deviceId);

  /// The current member [deviceId] belongs to; null when it never joined,
  /// left, or its member was removed.
  String? activeMemberOf(String deviceId) =>
      isActive(deviceId) ? _bindings[deviceId]?.memberId : null;

  /// A new one-time code for [memberId], asked by an admin on [deviceId].
  /// Any unused code for the same member stops working: one live code per
  /// person.
  ///
  /// Throws [NotMemberException], [ForbiddenException],
  /// [NotFoundException] or [StorageException].
  Future<IssuedCode> issueCode(String deviceId, String memberId) async {
    _requireAdmin(deviceId);
    if (_members[memberId] case null || (removed: true, role: _)) {
      throw const NotFoundException('No such member');
    }
    for (final MapEntry(:key, :value) in _issued.entries.toList()) {
      if (value.memberId == memberId && !value.used) {
        _issued[key] = value.copyWith(used: true);
      }
    }
    var code = _newCode();
    while (_issued.containsKey(code)) {
      code = _newCode();
    }
    final issued = _Code(
      memberId: memberId,
      expiresAt: _clock().add(codeLifetime),
    );
    _issued[code] = issued;
    await _saveCodes();
    return (code: code, expiresAt: issued.expiresAt);
  }

  /// Binds [deviceId] to the member [code] was issued for, marks the code
  /// used and records that they joined. Returns the member's id.
  ///
  /// Throws [InvalidCodeException] or [StorageException].
  Future<String> join(String deviceId, String code) async {
    final key = normalizeCode(code);
    final issued = _issued[key];
    if (issued == null || _members[issued.memberId]?.removed != false) {
      throw const InvalidCodeException(CodeProblem.unknown, 'Unknown code');
    }
    if (issued.used) {
      throw const InvalidCodeException(CodeProblem.used, 'Code used');
    }
    if (!_clock().isBefore(issued.expiresAt)) {
      throw const InvalidCodeException(CodeProblem.expired, 'Code expired');
    }
    _issued[key] = issued.copyWith(used: true);
    _bindings[deviceId] = _Binding(memberId: issued.memberId);
    final at = _clock();
    await _persist([
      _store(
        CareEvent.memberJoined(
          meta: EventMeta(
            id: 'joined-$deviceId-${at.microsecondsSinceEpoch}',
            caregiverId: systemAuthor,
            occurredAt: at,
          ),
          memberId: issued.memberId,
        ),
        sequence: _lastSequence + 1,
      ),
    ]);
    await _saveCodes();
    return issued.memberId;
  }

  /// Creates the circle for [recipientName] and makes [creatorName] its
  /// first admin, joined on [deviceId]: what a real app does on its first
  /// run. Returns the new member's id.
  ///
  /// Throws [ForbiddenException] when the server already has a circle
  /// (the demo has room for one), or [StorageException].
  Future<String> createCircle(
    String deviceId, {
    required String creatorName,
    required String recipientName,
  }) async {
    if (_hasCircle || _members.isNotEmpty) {
      throw const ForbiddenException('This server already has a circle');
    }
    final at = _clock();
    final stamp = at.microsecondsSinceEpoch;
    final memberId = 'member-$stamp';
    EventMeta meta(String what) => EventMeta(
      id: 'system-$stamp-$what',
      caregiverId: systemAuthor,
      occurredAt: at,
    );
    final events = [
      CareEvent.circleCreated(
        meta: meta('1-circle'),
        recipientName: recipientName,
      ),
      CareEvent.memberInvited(
        meta: meta('2-invited'),
        memberId: memberId,
        name: creatorName,
        role: MemberRole.admin,
        colorIndex: 0,
      ),
      CareEvent.memberJoined(meta: meta('3-joined'), memberId: memberId),
    ];
    _bindings[deviceId] = _Binding(memberId: memberId);
    await _persist([
      for (final (index, event) in events.indexed)
        _store(event, sequence: _lastSequence + index + 1),
    ]);
    return memberId;
  }

  /// Deletes the circle with everything in it, asked by an admin on
  /// [deviceId]. The demo's server has room for one circle, so it empties
  /// as when the demo starts without data; every other phone then learns
  /// it is no longer in a circle.
  ///
  /// Throws [NotMemberException], [ForbiddenException] or
  /// [StorageException].
  Future<void> deleteCircle(String deviceId) async {
    _requireAdmin(deviceId);
    await startEmpty();
  }

  /// The email of the Google account protecting [deviceId]'s access;
  /// null when none does.
  String? protectedWith(String deviceId) => _accounts.entries
      .where((account) => account.value == deviceId)
      .map((account) => account.key)
      .firstOrNull;

  /// Protects [deviceId]'s access with the Google account [email].
  ///
  /// Throws [NotMemberException] or [AccountInUseException].
  void protect(String deviceId, String email) {
    if (!isActive(deviceId)) {
      throw const NotMemberException('Not in the circle');
    }
    if (_accounts[email] case final String owner when owner != deviceId) {
      throw const AccountInUseException('The account protects another');
    }
    _accounts[email] = deviceId;
  }

  /// Makes [deviceId] the member whose access [email] protects. The
  /// device that had it becomes a stranger, as a phone whose session
  /// ended does on Supabase, and the circle is told. Returns the member's
  /// id.
  ///
  /// Throws [NoAccessException] or [StorageException].
  Future<String> recover(String deviceId, String email) async {
    final previous = _accounts[email];
    final memberId = previous == null ? null : activeMemberOf(previous);
    if (previous == null || memberId == null) {
      throw const NoAccessException('No access with this account');
    }
    if (previous == deviceId) return memberId;
    _bindings.remove(previous);
    await hiveGuardAsync('Server devices', () => _devices.delete(previous));
    _accounts[email] = deviceId;
    await bind(deviceId, memberId);
    final at = _clock();
    await _persist([
      _store(
        CareEvent.accessRecovered(
          meta: EventMeta(
            id: 'recovered-$deviceId-${at.microsecondsSinceEpoch}',
            caregiverId: systemAuthor,
            occurredAt: at,
          ),
          memberId: memberId,
        ),
        sequence: _lastSequence + 1,
      ),
    ]);
    return memberId;
  }

  /// Empties everything and remembers that the demo started without data.
  ///
  /// Throws [StorageException].
  Future<void> startEmpty() async {
    await clear();
    await hiveGuardAsync(
      'Server settings',
      () => _settings.put(_startedEmptyKey, 'true'),
    );
  }

  /// [code] as stored: upper case, without spaces or dashes, so "k7p 4qm"
  /// works as well as "K7P-4QM".
  static String normalizeCode(String code) =>
      code.toUpperCase().replaceAll(RegExp('[^A-Z0-9]'), '');

  /// Encoded events after [cursor] in server order, and the cursor that
  /// follows them. With [deviceId], only what that device's member may
  /// read (`docs/roles.md`, "Data by role"); the cursor still covers
  /// everything, so nothing is sent twice.
  ({List<String> events, String cursor}) eventsAfter(
    String? cursor, {
    String? deviceId,
  }) {
    final after = int.tryParse(cursor ?? '') ?? 0;
    final role = switch (deviceId) {
      final String id => _members[_bindings[id]?.memberId]?.role,
      null => null,
    };
    final readable = role == null
        ? Audience.values.toSet()
        : audiencesFor(role);
    return (
      events: [
        for (final record in _records)
          if (record.sequence > after &&
              readable.contains(_audiences[record.id] ?? Audience.care))
            record.event,
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
    _audiences.clear();
    _lastReceivedAt = null;
    _hasCircle = false;
    _bindings.clear();
    _accounts.clear();
    _issued.clear();
    await hiveGuardAsync('Server log', _box.clear);
    await hiveGuardAsync('Server devices', _devices.clear);
    await hiveGuardAsync('Server codes', _codes.clear);
    await hiveGuardAsync('Server settings', _settings.clear);
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

  /// Throws [NotMemberException] or [ForbiddenException].
  void _requireAdmin(String deviceId) {
    if (!isActive(deviceId)) {
      throw const NotMemberException('Device not in the circle');
    }
    final role = _members[_bindings[deviceId]?.memberId]?.role;
    if (role == null || !can(role, CareAction.manageMembers)) {
      throw const ForbiddenException('Only admins manage members');
    }
  }

  String _newCode() {
    String half() => [
      for (var i = 0; i < _codeHalf; i++)
        _codeAlphabet[_random.nextInt(_codeAlphabet.length)],
    ].join();
    return '${half()}${half()}';
  }

  Future<void> _saveCodes() => hiveGuardAsync(
    'Server codes',
    () => _codes.putAll({
      for (final MapEntry(:key, :value) in _issued.entries) key: value.encode(),
    }),
  );

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
        receivedAt: _nextReceivedAt(),
        serverSeq: sequence,
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

  /// The server's time, but always after the last event's: the log is
  /// ordered by `receivedAt`, so events received in the same instant (one
  /// push, or a fixed clock) must still keep the order they arrived in.
  DateTime _nextReceivedAt() {
    final now = _clock();
    final last = _lastReceivedAt;
    final next = last != null && !now.isAfter(last)
        ? last.add(const Duration(microseconds: 1))
        : now;
    return _lastReceivedAt = next;
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
    _audiences[event.meta.id] = audienceOf(event);
    if (event is CircleCreated) _hasCircle = true;
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
      if (_bindings[deviceId] case _Binding(memberId: final bound, ended: false)
          when bound == memberId) {
        _bindings[deviceId] = _Binding(memberId: memberId, ended: true);
        _unprotect(deviceId);
      }
    }
  }

  /// A binding that ends takes the device's protection with it: the next
  /// person on that phone has an access of their own.
  void _unprotect(String deviceId) =>
      _accounts.removeWhere((_, protected) => protected == deviceId);
}

/// The outcome of checking one event.
class _Verdict {
  const _Verdict.accept({this.fromFormerMember = false}) : reason = null;
  const _Verdict.reject(RejectionReason this.reason) : fromFormerMember = false;

  final RejectionReason? reason;
  final bool fromFormerMember;
}

/// An issued invitation code: whom it is for, until when, and whether it
/// was used (or replaced by a newer one).
class _Code {
  const _Code({
    required this.memberId,
    required this.expiresAt,
    this.used = false,
  });

  /// Throws [ParsingException].
  factory _Code.decode(String value) {
    final Object? json;
    try {
      json = jsonDecode(value);
    } on FormatException catch (error) {
      throw ParsingException('Corrupted invitation code', cause: error);
    }
    if (json case {
      'member': final String memberId,
      'expires_at': final String expiresAt,
      'used': final bool used,
    }) {
      if (DateTime.tryParse(expiresAt) case final DateTime at) {
        return _Code(memberId: memberId, expiresAt: at, used: used);
      }
    }
    throw const ParsingException('Corrupted invitation code');
  }

  final String memberId;
  final DateTime expiresAt;
  final bool used;

  _Code copyWith({required bool used}) =>
      _Code(memberId: memberId, expiresAt: expiresAt, used: used);

  String encode() => jsonEncode({
    'member': memberId,
    'expires_at': expiresAt.toIso8601String(),
    'used': used,
  });
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

  _Record withEvent(String event) =>
      _Record(sequence: sequence, id: id, event: event);

  String encode() => jsonEncode({'seq': sequence, 'id': id, 'event': event});
}
