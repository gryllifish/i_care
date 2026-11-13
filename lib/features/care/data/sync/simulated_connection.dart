import 'dart:async';

import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/features/care/data/mappers/care_event_codec.dart';
import 'package:i_care/features/care/data/sync/access_gateway.dart';
import 'package:i_care/features/care/data/sync/membership_gateway.dart';
import 'package:i_care/features/care/data/sync/simulated_server.dart';
import 'package:i_care/features/care/data/sync/sync_gateway.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/invite_code.dart';
import 'package:i_care/features/care/domain/entities/rejected_event.dart';

/// One device's link to the [SimulatedServer], with network latency and
/// an offline switch so the demo can reproduce what real networks do.
/// The server knows the device by [deviceId], as a real one would by the
/// signed-in account.
class SimulatedConnection
    implements SyncGateway, MembershipGateway, AccessGateway {
  SimulatedConnection(
    this._server, {
    required this.deviceId,
    this._latency = Duration.zero,
  });

  final SimulatedServer _server;
  final String deviceId;
  final Duration _latency;
  final _connectivity = StreamController<bool>.broadcast();
  var _isOnline = true;

  bool get isOnline => _isOnline;

  /// Turns the simulated network on or off for this device only.
  set isOnline(bool value) {
    if (value == _isOnline) return;
    _isOnline = value;
    _connectivity.add(value);
  }

  @override
  Future<PushResult> push(List<CareEvent> events) async {
    await _travel();
    final result = await _server.receive(deviceId, [
      for (final event in events) CareEventCodec.encodeString(event),
    ]);
    await _travel();
    final byId = {for (final event in events) event.meta.id: event};
    return (
      stored: [
        for (final value in result.stored) CareEventCodec.decodeString(value),
      ],
      rejected: [
        for (final (:id, :reason) in result.rejected)
          if (byId[id] case final event?)
            RejectedEvent(event: event, reason: reason),
      ],
    );
  }

  @override
  Stream<SyncBatch> watch({String? cursor}) {
    var position = cursor;
    late final StreamController<SyncBatch> controller;
    final subscriptions = <StreamSubscription<Object?>>[];
    var delivering = Future<void>.value();

    Future<void> deliver() async {
      if (!_isOnline) {
        controller.addError(const NoConnectionException('Offline'));
        return;
      }
      await Future<void>.delayed(_latency);
      // The connection may have dropped while the batch was in flight.
      if (!_isOnline || controller.isClosed) return;
      // Only members read the log; a removed device learns it here.
      if (!_server.isActive(deviceId)) {
        controller.addError(const NotMemberException('Not in the circle'));
        return;
      }
      final batch = _server.eventsAfter(position, deviceId: deviceId);
      position = batch.cursor;
      final events = <CareEvent>[];
      final unreadable = <String>[];
      for (final value in batch.events) {
        switch (CareEventCodec.tryDecodeString(value)) {
          case final event?:
            events.add(event);
          case null:
            unreadable.add(value);
        }
      }
      controller.add((
        events: events,
        unreadable: unreadable,
        cursor: batch.cursor,
      ));
    }

    // Deliveries run one at a time so batches never overlap or reorder.
    void schedule() => delivering = delivering.then((_) => deliver());

    controller = StreamController<SyncBatch>(
      onListen: () {
        subscriptions
          ..add(_server.appended.listen((_) => schedule()))
          ..add(_connectivity.stream.listen((_) => schedule()));
        schedule();
      },
      onCancel: () async {
        for (final subscription in subscriptions) {
          await subscription.cancel();
        }
      },
    );
    return controller.stream;
  }

  @override
  Future<InviteCode> issueCode(String memberId) async {
    await _travel();
    final issued = await _server.issueCode(deviceId, memberId);
    await _travel();
    return InviteCode(code: _display(issued.code), expiresAt: issued.expiresAt);
  }

  @override
  Future<String> createCircle({
    required String creatorName,
    required String recipientName,
  }) async {
    await _travel();
    final memberId = await _server.createCircle(
      deviceId,
      creatorName: creatorName,
      recipientName: recipientName,
    );
    await _travel();
    return memberId;
  }

  @override
  Future<String> join(String code) async {
    await _travel();
    final memberId = await _server.join(deviceId, code);
    await _travel();
    return memberId;
  }

  @override
  Future<void> deleteCircle() async {
    await _travel();
    await _server.deleteCircle(deviceId);
    await _travel();
  }

  // The simulated server knows a device by its id, which has no session.
  @override
  Future<void> forgetDevice() async {}

  @override
  Future<String?> protectedWith() async => _server.protectedWith(deviceId);

  @override
  Future<String> protect(GoogleCredential credential) async {
    await _travel();
    _server.protect(deviceId, credential.email);
    await _travel();
    return credential.email;
  }

  @override
  Future<String> recover(GoogleCredential credential) async {
    await _travel();
    final memberId = await _server.recover(deviceId, credential.email);
    await _travel();
    return memberId;
  }

  /// "K7P4QM" as "K7P-4QM": easier to read aloud and type.
  static String _display(String code) =>
      '${code.substring(0, code.length ~/ 2)}-'
      '${code.substring(code.length ~/ 2)}';

  Future<void> _travel() async {
    if (!_isOnline) throw const NoConnectionException('Offline');
    await Future<void>.delayed(_latency);
    if (!_isOnline) throw const NoConnectionException('Connection lost');
  }

  Future<void> dispose() => _connectivity.close();
}
