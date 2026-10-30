import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/data/sample/sample_circle.dart';
import 'package:i_care/features/care/domain/entities/dose_slot.dart';
import 'package:i_care/features/care/domain/entities/task_slot.dart';
import 'package:i_care/features/care/domain/projections/care_log.dart';

void main() {
  final now = DateTime(2026, 11, 2, 15);
  final today = DateTime(2026, 11, 2);

  CareLog circleIn(String language) =>
      CareLog(SampleCircle.events(now, language: language));

  test('is written in the device language', () {
    String names(CareLog log) =>
        log.medications.map((m) => m.details.name).join(', ');

    expect(
      names(circleIn('es')),
      'Enalapril, Levotiroxina, Metformina, Paracetamol',
    );
    expect(
      names(circleIn('en')),
      'Enalapril, Levothyroxine, Metformin, Paracetamol',
    );
    expect(names(circleIn('fr')), names(circleIn('en')));
  });

  test('leaves one dose from yesterday unresolved and today on track', () {
    final log = circleIn('es');

    expect(log.fromYesterday(today, now: now), hasLength(1));
    expect(
      log.slotsOn(today, now: now).where((s) => s.slotAt.isBefore(now)),
      everyElement(
        isA<DoseSlot>().having((s) => s.status, 'status', DoseStatus.given),
      ),
    );
    expect(log.conflicts, isEmpty);
  });

  test('levothyroxine runs low on stock', () {
    final log = circleIn('en');

    expect(log.stockOf('levothyroxine')?.isLow, isTrue);
    expect(log.stockOf('enalapril')?.isLow, isFalse);
  });

  test('has care tasks: done before now, untimed ones still to do', () {
    final log = circleIn('en');

    expect(log.tasks.map((task) => task.details.name), [
      'Bath',
      'Change the bedding',
      'Check the skin',
      'Short walk',
    ]);
    // 2026-11-02 is a Monday: bath day, not bedding day.
    final statuses = {
      for (final slot in log.taskSlotsOn(today, now: now))
        slot.task.details.name: slot.status,
    };
    expect(statuses, {
      'Check the skin': TaskStatus.due,
      'Bath': TaskStatus.done,
      'Short walk': TaskStatus.upcoming,
    });
    expect(log.conflicts, isEmpty);
  });
}
