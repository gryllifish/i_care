import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/appointments/controllers/appointments_view.dart';
import 'package:i_care/features/care/domain/projections/care_log.dart';

import '../../care/helpers/care_events.dart';

void main() {
  late EventFactory events;
  final now = DateTime(2026, 11, 2, 12);

  setUp(() => events = EventFactory());

  test('splits upcoming (soonest first) from past (latest first)', () {
    final view = buildAppointmentsView(
      CareLog([
        events.appointment('old', startsAt: DateTime(2026, 10, 20, 9)),
        events.appointment('recent', startsAt: DateTime(2026, 11, 1, 9)),
        events.appointment('later', startsAt: DateTime(2026, 11, 9, 9)),
        events.appointment('soon', startsAt: DateTime(2026, 11, 3, 9)),
      ]),
      now,
    );

    expect(view.upcoming.map((a) => a.id), ['soon', 'later']);
    expect(view.past.map((a) => a.id), ['recent', 'old']);
  });

  test('an appointment stays upcoming while people are there', () {
    final view = buildAppointmentsView(
      CareLog([events.appointment('now', startsAt: DateTime(2026, 11, 2, 11))]),
      now,
    );

    expect(view.upcoming.single.id, 'now');
  });

  test('recent past appointments without notes ask for them', () {
    final view = buildAppointmentsView(
      CareLog([
        events.appointment('noted', startsAt: DateTime(2026, 11, 1, 9)),
        events.note('noted', 'All fine'),
        events.appointment('silent', startsAt: DateTime(2026, 11, 1, 10)),
        events.appointment('ancient', startsAt: DateTime(2026, 9)),
      ]),
      now,
    );

    expect(view.missingNotes, {'silent'});
  });
}
