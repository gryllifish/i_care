import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/activity/controllers/activity_view.dart';
import 'package:i_care/features/care/domain/projections/care_log.dart';

import '../../care/helpers/care_events.dart';

void main() {
  late EventFactory events;

  setUp(() => events = EventFactory());

  test('groups entries by day, newest first', () {
    final created = events.created('m1', at: DateTime(2026, 11));
    final morning = events.given('m1', at: DateTime(2026, 11, 2, 8));
    final evening = events.given('m1', at: DateTime(2026, 11, 2, 20));

    final days = buildActivity(CareLog([created, morning, evening]));

    expect(days.map((d) => d.day), [DateTime(2026, 11, 2), DateTime(2026, 11)]);
    expect(days.first.entries.map((e) => e.event), [evening, morning]);
  });

  test('names the medication, through the cancelled record for undos', () {
    final given = events.given('m1', at: DateTime(2026, 11, 2, 8));
    final days = buildActivity(
      CareLog([
        events.created('m1', at: DateTime(2026, 11)),
        given,
        events.undone(given, at: DateTime(2026, 11, 2, 9)),
      ]),
    );

    expect(
      days.expand((d) => d.entries).map((e) => e.medicationName),
      everyElement('Enalapril'),
    );
  });

  test('acknowledged conflicts have no medication', () {
    final days = buildActivity(CareLog([events.acknowledged('dose:m1:x')]));

    expect(days.single.entries.single.medicationName, isNull);
  });
}
