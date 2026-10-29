import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/projections/care_log.dart';
import 'package:i_care/features/care/domain/projections/dose_warnings.dart';

import '../../helpers/care_events.dart';

void main() {
  late EventFactory events;
  final eight = DateTime(2026, 11, 2, 8);
  final justSynced = eight;

  setUp(() => events = EventFactory());

  List<DoseWarning> warn(
    List<CareEvent> log, {
    DateTime? slotAt,
    DateTime? now,
    DateTime? lastSyncedAt,
  }) {
    final careLog = CareLog(log);
    final medication = careLog.medication('m1');
    if (medication == null) throw StateError('m1 missing');
    return doseWarnings(
      careLog,
      medication: medication,
      slotAt: slotAt,
      now: now ?? eight,
      lastSyncedAt: lastSyncedAt ?? justSynced,
    );
  }

  test('nothing to warn about for a pending dose on a synced device', () {
    expect(warn([events.created('m1')], slotAt: eight), isEmpty);
  });

  test('warns when the dose was already given, naming that dose', () {
    final given = events.given('m1', at: eight, slotAt: eight, by: 'martin');

    expect(warn([events.created('m1'), given], slotAt: eight), [
      isA<AlreadyGiven>().having((w) => w.dose, 'dose', given),
    ]);
  });

  test('warns before the entered minimum interval has passed', () {
    final log = [
      events.created(
        'm1',
        schedule: const DoseSchedule.asNeeded(minInterval: Duration(hours: 6)),
      ),
      events.given('m1', at: eight),
    ];
    final twoHoursLater = eight.add(const Duration(hours: 2));

    expect(warn(log, now: twoHoursLater, lastSyncedAt: twoHoursLater), [
      isA<TooSoon>().having(
        (w) => w.allowedFrom,
        'allowedFrom',
        eight.add(const Duration(hours: 6)),
      ),
    ]);
  });

  test('warns when the entered daily maximum was reached', () {
    final log = [
      events.created(
        'm1',
        schedule: const DoseSchedule.asNeeded(
          minInterval: Duration(hours: 1),
          maxPerDay: 2,
        ),
      ),
      events.given('m1', at: eight),
      events.given('m1', at: eight.add(const Duration(hours: 2))),
    ];
    final noon = DateTime(2026, 11, 2, 12);

    expect(warn(log, now: noon, lastSyncedAt: noon), [
      isA<DailyLimitReached>().having((w) => w.given, 'given', 2),
    ]);
  });

  test('warns when the device has not synced recently', () {
    final log = [events.created('m1')];

    expect(
      warn(
        log,
        slotAt: eight,
        lastSyncedAt: eight.subtract(staleSyncAfter * 2),
      ),
      [isA<OutOfDate>()],
    );
  });

  test('the doses a warning showed become known when confirming', () {
    final given = events.given('m1', at: eight, slotAt: eight);
    final warnings = warn(
      [events.created('m1'), given],
      slotAt: eight,
      lastSyncedAt: eight.subtract(staleSyncAfter * 2),
    );

    expect(knownDoseIdsOf(warnings), [given.meta.id]);
  });
}
