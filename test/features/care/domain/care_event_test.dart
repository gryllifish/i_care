import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';

import '../helpers/care_events.dart';

void main() {
  final events = EventFactory();
  final morning = DateTime(2026, 11, 2, 8);

  test('synced events come first, by server time, whatever the device '
      'clock says', () {
    final late = events.given(
      'm1',
      at: morning,
      receivedAt: morning.add(const Duration(minutes: 5)),
    );
    final early = events.given(
      'm1',
      // A device clock an hour ahead.
      at: morning.add(const Duration(hours: 1)),
      receivedAt: morning.add(const Duration(minutes: 1)),
    );
    final pending = events.given('m1', at: morning.subtract(_hour));

    expect([pending, late, early]..sort(compareEvents), [early, late, pending]);
  });

  test('pending events are ordered by device time', () {
    final second = events.given('m1', at: morning.add(_hour));
    final first = events.given('m1', at: morning);

    expect([second, first]..sort(compareEvents), [first, second]);
  });

  test('ids break ties so every device sorts alike', () {
    final b = events
        .given('m1', at: morning)
        .copyWith(
          meta: events.meta(at: morning, id: 'b'),
        );
    final a = events
        .given('m1', at: morning)
        .copyWith(
          meta: events.meta(at: morning, id: 'a'),
        );

    expect([b, a]..sort(compareEvents), [a, b]);
  });
}

const _hour = Duration(hours: 1);
