import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/data/mappers/care_event_codec.dart';
import 'package:i_care/features/care/data/sync/simulated_server.dart';

import '../../helpers/care_events.dart';
import '../../helpers/hive_boxes.dart';

void main() {
  final openBox = useTemporaryHive();
  final events = EventFactory();
  final serverTime = DateTime(2026, 11, 2, 9);

  test('stamps events with its own clock', () async {
    final server = SimulatedServer(
      await openBox(SimulatedServer.boxName),
      clock: () => serverTime,
    );
    final event = events.given('m1', at: DateTime(2026, 11, 2, 8));

    final [stored] = await server.receive([
      CareEventCodec.encodeString(event),
    ]);

    expect(CareEventCodec.decodeString(stored).meta.receivedAt, serverTime);
  });

  test('keeps its log across restarts', () async {
    final box = await openBox(SimulatedServer.boxName);
    final first = SimulatedServer(box, clock: () => serverTime);
    await first.receive([
      CareEventCodec.encodeString(events.given('m1', at: serverTime)),
    ]);

    final restarted = SimulatedServer(box, clock: () => serverTime);

    expect(restarted.eventsAfter(null).events, hasLength(1));
    expect(restarted.eventsAfter(null).cursor, '1');
  });

  test('clear empties the log', () async {
    final server = SimulatedServer(
      await openBox(SimulatedServer.boxName),
      clock: () => serverTime,
    );
    await server.receive([
      CareEventCodec.encodeString(events.given('m1', at: serverTime)),
    ]);

    await server.clear();

    expect(server.isEmpty, isTrue);
  });
}
