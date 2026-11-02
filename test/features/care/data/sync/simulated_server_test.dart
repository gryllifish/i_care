import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/data/mappers/care_event_codec.dart';
import 'package:i_care/features/care/data/sample/sample_circle.dart';
import 'package:i_care/features/care/data/sync/simulated_server.dart';
import 'package:i_care/features/care/domain/entities/rejected_event.dart';

import '../../helpers/care_events.dart';
import '../../helpers/hive_boxes.dart';

void main() {
  final openBox = useTemporaryHive();
  final events = EventFactory();
  final serverTime = DateTime(2026, 11, 2, 9);

  /// A server with the sample circle's members, Ana's phone joined.
  Future<SimulatedServer> openServer() async {
    final server = SimulatedServer(
      await openBox(SimulatedServer.boxName),
      await openBox(SimulatedServer.devicesBoxName),
      clock: () => serverTime,
    );
    await server.seed([
      for (final event in SampleCircle.memberEvents(DateTime(2025)))
        CareEventCodec.encodeString(event),
    ]);
    await server.bind('phone-ana', 'ana');
    return server;
  }

  String encoded(DateTime at) =>
      CareEventCodec.encodeString(events.given('m1', at: at));

  test('stamps events with its own clock', () async {
    final server = await openServer();

    final result = await server.receive('phone-ana', [
      encoded(DateTime(2026, 11, 2, 8)),
    ]);

    expect(
      CareEventCodec.decodeString(result.stored.single).meta.receivedAt,
      serverTime,
    );
  });

  test('keeps its log, members and devices across restarts', () async {
    final first = await openServer();
    await first.receive('phone-ana', [encoded(serverTime)]);
    final members = SampleCircle.memberEvents(DateTime(2025)).length;

    final restarted = SimulatedServer(
      await openBox(SimulatedServer.boxName),
      await openBox(SimulatedServer.devicesBoxName),
      clock: () => serverTime,
    );

    expect(restarted.eventsAfter(null).events, hasLength(members + 1));
    expect(restarted.hasMembers, isTrue);
    final again = await restarted.receive('phone-ana', [encoded(serverTime)]);
    expect(again.rejected, isEmpty);
  });

  test('refuses a device that never joined', () async {
    final server = await openServer();

    final result = await server.receive('phone-unknown', [
      encoded(serverTime),
    ]);

    expect(result.rejected.single.reason, RejectionReason.notMember);
  });

  test('clear empties the log, members and devices', () async {
    final server = await openServer();
    await server.receive('phone-ana', [encoded(serverTime)]);

    await server.clear();

    expect(server.isEmpty, isTrue);
    expect(server.hasMembers, isFalse);
  });
}
