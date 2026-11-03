import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/data/datasources/event_store.dart';
import 'package:i_care/features/care/data/mappers/care_event_codec.dart';

import '../../helpers/care_events.dart';
import '../../helpers/hive_boxes.dart';

void main() {
  final openBox = useTemporaryHive();
  late EventStore store;
  final events = EventFactory();
  final eight = DateTime(2026, 11, 2, 8);

  setUp(() async => store = EventStore(await openBox('events')));

  test('stored events read back, pending ones apart', () async {
    final synced = events.given('m1', at: eight, receivedAt: eight);
    final pending = events.given('m1', at: eight);

    await store.merge([synced, pending]);

    expect(store.readAll(), unorderedEquals([synced, pending]));
    expect(store.readPending(), [pending]);
  });

  test('a synced copy replaces the pending one', () async {
    final pending = events.given('m1', at: eight);
    final synced = pending.copyWith(
      meta: pending.meta.copyWith(receivedAt: eight),
    );

    await store.merge([pending]);
    await store.merge([synced]);

    expect(store.readAll(), [synced]);
  });

  test('events from a newer app version are kept but not read', () async {
    final known = events.given('m1', at: eight, receivedAt: eight);
    final newer = jsonEncode({
      ...CareEventCodec.encode(known),
      'id': 'from-the-future',
      'type': 'dose_teleported',
    });

    await store.merge([known]);
    await store.keepUnreadable([newer]);

    expect(store.readAll(), [known]);
    expect(store.readPending(), isEmpty);
  });

  test('a pending copy never replaces a synced one', () async {
    final pending = events.given('m1', at: eight);
    final synced = pending.copyWith(
      meta: pending.meta.copyWith(receivedAt: eight),
    );

    await store.merge([synced]);
    await store.merge([pending]);

    expect(store.readAll(), [synced]);
  });
}
