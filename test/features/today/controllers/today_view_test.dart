import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/entities/dose_slot.dart';
import 'package:i_care/features/care/domain/projections/care_log.dart';
import 'package:i_care/features/today/controllers/today_view.dart';

import '../../care/helpers/care_events.dart';

void main() {
  late EventFactory events;
  final eight = DateTime(2026, 11, 2, 8);

  setUp(() => events = EventFactory());

  TodayView viewAt(DateTime now, [List<Object> extra = const []]) =>
      buildTodayView(
        CareLog([
          events.created('m1'),
          events.created(
            'm2',
            name: 'Paracetamol',
            schedule: const DoseSchedule.asNeeded(
              minInterval: Duration(hours: 6),
            ),
          ),
          ...extra.cast(),
        ]),
        now,
      );

  test('next is the earliest dose due or late, yesterday first', () {
    final view = viewAt(DateTime(2026, 11, 2, 9));

    expect(view.next?.slotAt, DateTime(2026, 11, 1, 8));
    expect(view.fromYesterday.map((s) => s.slotAt), [
      DateTime(2026, 11, 1, 8),
      DateTime(2026, 11, 1, 20),
    ]);
  });

  test('next is the upcoming dose when nothing is pending', () {
    final yesterday = DateTime(2026, 11, 1, 8);
    final yesterdayNight = DateTime(2026, 11, 1, 20);
    final view = viewAt(DateTime(2026, 11, 2, 12), [
      events.given('m1', at: yesterday, slotAt: yesterday),
      events.given('m1', at: yesterdayNight, slotAt: yesterdayNight),
      events.given('m1', at: eight, slotAt: eight),
    ]);

    expect(view.next?.slotAt, DateTime(2026, 11, 2, 20));
    expect(view.next?.status, DoseStatus.upcoming);
  });

  test('doses are grouped by part of the day, empty parts left out', () {
    final view = viewAt(DateTime(2026, 11, 2, 9));

    expect(view.byDayPart.keys, [DayPart.morning, DayPart.night]);
  });

  test('as-needed medications come with their last dose', () {
    final dose = events.given('m2', at: eight);
    final view = viewAt(DateTime(2026, 11, 2, 9), [dose]);

    expect(view.asNeeded.single.medication.id, 'm2');
    expect(view.asNeeded.single.lastDose, dose);
  });
}
