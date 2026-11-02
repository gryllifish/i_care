import 'dart:async';

import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/features/care/data/mappers/care_event_codec.dart';
import 'package:i_care/features/care/data/sync/simulated_server.dart';
import 'package:i_care/features/care/data/sync/sync_gateway.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/rejected_event.dart';

/// One device's link to the [SimulatedServer], with network latency and
/// an offline switch so the demo can reproduce what real networks do.
/// The server knows the device by [deviceId], as a real one would by the
/// signed-in account.
class SimulatedConnection implements SyncGateway {
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
      final batch = _server.eventsAfter(position);
      position = batch.cursor;
      controller.add((
        events: [
          for (final value in batch.events) CareEventCodec.decodeString(value),
        ],
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

  Future<void> _travel() async {
    if (!_isOnline) throw const NoConnectionException('Offline');
    await Future<void>.delayed(_latency);
    if (!_isOnline) throw const NoConnectionException('Connection lost');
  }

  Future<void> dispose() => _connectivity.close();
}
