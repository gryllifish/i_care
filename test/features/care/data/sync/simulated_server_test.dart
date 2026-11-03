import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/core/error/app_exception.dart';
import 'package:i_care/core/error/failure.dart';
import 'package:i_care/features/care/data/mappers/care_event_codec.dart';
import 'package:i_care/features/care/data/sample/sample_circle.dart';
import 'package:i_care/features/care/data/sync/simulated_server.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
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
      await openBox(SimulatedServer.codesBoxName),
      await openBox(SimulatedServer.settingsBoxName),
      clock: () => serverTime,
    );
    await server.seed([
      for (final event in SampleCircle.circleEvents(DateTime(2025)))
        CareEventCodec.encodeString(event),
    ]);
    await server.bind('phone-ana', 'ana');
    await server.bind('phone-martin', 'martin');
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
      receivedAround(serverTime),
    );
  });

  test(
    'events received in the same instant keep their arrival order',
    () async {
      final server = await openServer();
      final first = events.given('m1', at: serverTime, id: 'z-first');
      final second = events.given('m1', at: serverTime, id: 'a-second');

      final result = await server.receive('phone-ana', [
        CareEventCodec.encodeString(first),
        CareEventCodec.encodeString(second),
      ]);

      final [stored1, stored2] = [
        for (final value in result.stored) CareEventCodec.decodeString(value),
      ];
      // Ids would put the second one first; the server's time must not.
      expect(compareEvents(stored1, stored2), lessThan(0));
    },
  );

  test('keeps its log, members and devices across restarts', () async {
    final first = await openServer();
    await first.receive('phone-ana', [encoded(serverTime)]);
    final members = SampleCircle.circleEvents(DateTime(2025)).length;

    final restarted = SimulatedServer(
      await openBox(SimulatedServer.boxName),
      await openBox(SimulatedServer.devicesBoxName),
      await openBox(SimulatedServer.codesBoxName),
      await openBox(SimulatedServer.settingsBoxName),
      clock: () => serverTime,
    );

    expect(restarted.eventsAfter(null).events, hasLength(members + 1));
    expect(restarted.hasMembers, isTrue);
    final again = await restarted.receive('phone-ana', [encoded(serverTime)]);
    expect(again.rejected, isEmpty);
  });

  test('refuses a device that never joined', () async {
    final server = await openServer();

    final result = await server.receive('phone-unknown', [encoded(serverTime)]);

    expect(result.rejected.single.reason, RejectionReason.notMember);
  });

  test('clear empties the log, members and devices', () async {
    final server = await openServer();
    await server.receive('phone-ana', [encoded(serverTime)]);

    await server.clear();

    expect(server.isEmpty, isTrue);
    expect(server.hasMembers, isFalse);
  });

  group('invitation codes', () {
    test("an admin's code joins a new device as that member, once", () async {
      final server = await openServer();
      final issued = await server.issueCode('phone-ana', 'rosa');

      expect(issued.expiresAt, serverTime.add(SimulatedServer.codeLifetime));
      expect(server.isActive('phone-new'), isFalse);

      final memberId = await server.join(
        'phone-new',
        issued.code.toLowerCase(),
      );

      expect(memberId, 'rosa');
      expect(server.isActive('phone-new'), isTrue);
      final joined = CareEventCodec.decodeString(
        server.eventsAfter(null).events.last,
      );
      expect(joined.meta.caregiverId, 'system');
      await expectLater(
        server.join('phone-other', issued.code),
        throwsA(
          isA<InvalidCodeException>().having(
            (e) => e.problem,
            'problem',
            CodeProblem.used,
          ),
        ),
      );
    });

    test('only admins issue codes', () async {
      final server = await openServer();

      await expectLater(
        server.issueCode('phone-martin', 'rosa'),
        throwsA(isA<ForbiddenException>()),
      );
    });

    test('a new code replaces an unused one', () async {
      final server = await openServer();
      final first = await server.issueCode('phone-ana', 'rosa');
      await server.issueCode('phone-ana', 'rosa');

      await expectLater(
        server.join('phone-new', first.code),
        throwsA(isA<InvalidCodeException>()),
      );
    });

    test('codes expire by the server clock', () async {
      var now = serverTime;
      final server = SimulatedServer(
        await openBox(SimulatedServer.boxName),
        await openBox(SimulatedServer.devicesBoxName),
        await openBox(SimulatedServer.codesBoxName),
        await openBox(SimulatedServer.settingsBoxName),
        clock: () => now,
      );
      await server.seed([
        for (final event in SampleCircle.circleEvents(DateTime(2025)))
          CareEventCodec.encodeString(event),
      ]);
      await server.bind('phone-ana', 'ana');
      final issued = await server.issueCode('phone-ana', 'rosa');

      now = now.add(SimulatedServer.codeLifetime);

      await expectLater(
        server.join('phone-new', issued.code),
        throwsA(
          isA<InvalidCodeException>().having(
            (e) => e.problem,
            'problem',
            CodeProblem.expired,
          ),
        ),
      );
    });

    test('an unknown code is refused', () async {
      final server = await openServer();

      await expectLater(
        server.join('phone-new', 'AAA-AAA'),
        throwsA(
          isA<InvalidCodeException>().having(
            (e) => e.problem,
            'problem',
            CodeProblem.unknown,
          ),
        ),
      );
    });
  });

  test(
    'a device that leaves, or whose member is removed, stops reading',
    () async {
      final server = await openServer();

      await server.receive('phone-martin', [
        CareEventCodec.encodeString(events.memberLeft('martin', by: 'martin')),
      ]);
      await server.receive('phone-ana', [
        CareEventCodec.encodeString(
          events.memberRemoved('rosa', baseVersion: 0),
        ),
      ]);
      await server.bind('phone-rosa', 'rosa');

      expect(server.isActive('phone-martin'), isFalse);
      expect(server.isActive('phone-rosa'), isFalse);
      expect(server.isActive('phone-ana'), isTrue);
      expect(server.activeMemberOf('phone-ana'), 'ana');
      expect(server.activeMemberOf('phone-martin'), isNull);
      expect(server.activeMemberOf('phone-unknown'), isNull);
      expect(server.knowsDevice('phone-martin'), isTrue);
      expect(server.knowsDevice('phone-unknown'), isFalse);
    },
  );

  group('creating a circle', () {
    Future<SimulatedServer> emptyServer() async => SimulatedServer(
      await openBox(SimulatedServer.boxName),
      await openBox(SimulatedServer.devicesBoxName),
      await openBox(SimulatedServer.codesBoxName),
      await openBox(SimulatedServer.settingsBoxName),
      clock: () => serverTime,
    );

    test('makes its creator the first admin, on their device', () async {
      final server = await emptyServer();

      final memberId = await server.createCircle(
        'phone-1',
        creatorName: 'Lucía',
        recipientName: 'Abuela Rosa',
      );

      expect(server.activeMemberOf('phone-1'), memberId);
      expect(server.hasCircle, isTrue);
      final events = [
        for (final value in server.eventsAfter(null).events)
          CareEventCodec.decodeString(value),
      ];
      expect(events.first, isA<CircleCreated>());
      expect((events.first as CircleCreated).recipientName, 'Abuela Rosa');
      // The admin can invite at once.
      await server.issueCode('phone-1', memberId);
    });

    test('is refused while the server has a circle', () async {
      final server = await openServer();

      await expectLater(
        server.createCircle(
          'phone-new',
          creatorName: 'Lucía',
          recipientName: 'Abuela Rosa',
        ),
        throwsA(isA<ForbiddenException>()),
      );
    });

    test(
      'an empty start is remembered, and a sample reset forgets it',
      () async {
        final server = await openServer();

        await server.startEmpty();
        expect(server.isEmpty, isTrue);
        expect(server.startedEmpty, isTrue);

        await server.clear();
        expect(server.startedEmpty, isFalse);
      },
    );
  });
}
