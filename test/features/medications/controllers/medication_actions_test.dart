import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/features/care/data/care_providers.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/conflict.dart';
import 'package:i_care/features/care/domain/entities/dose_schedule.dart';
import 'package:i_care/features/care/domain/entities/medication.dart';
import 'package:i_care/features/care/domain/projections/care_log.dart';
import 'package:i_care/features/medications/controllers/medication_actions.dart';
import 'package:i_care/features/medications/controllers/medication_detail.dart';
import 'package:i_care/shared/providers/clock_provider.dart';
import 'package:i_care/shared/providers/device_prefs.dart';
import 'package:i_care/shared/providers/id_provider.dart';

import '../../../helpers/pump_app.dart';
import '../../care/helpers/care_events.dart';

void main() {
  final now = DateTime(2026, 11, 2, 9);
  late FakeCareRepository repository;
  late ProviderContainer container;
  late EventFactory events;

  setUp(() {
    events = EventFactory();
    repository = FakeCareRepository();
    var nextId = 0;
    container = ProviderContainer.test(
      overrides: [
        careRepositoryProvider.overrideWithValue(repository),
        clockProvider.overrideWithValue(() => now),
        newIdProvider.overrideWithValue(() => 'id-${nextId++}'),
        devicePrefsProvider.overrideWithValue(
          MemoryDevicePrefs({PrefKeys.memberId: 'ana'}),
        ),
      ],
    );
  });

  MedicationActions actions() =>
      container.read(medicationActionsProvider.notifier);
  CareLog log() => CareLog(repository.events);

  const details = MedicationDetails(
    name: 'Enalapril',
    strength: '10 mg',
    form: MedicationForm.tablet,
  );

  test(
    'creating starts the schedule now and counts the initial stock',
    () async {
      final result = await actions().create(
        details: details,
        schedule: const DoseSchedule.fixed(minutesOfDay: [1200, 480]),
        initialStock: 30,
      );

      final id = (result as Ok<String>).value;
      final medication = log().medication(id);
      expect(medication?.details, details);
      expect(medication?.schedules.single.effectiveFrom, now);
      expect(
        medication?.schedule,
        const DoseSchedule.fixed(minutesOfDay: [480, 1200]),
      );
      expect(log().stockOf(id)?.units, 30);
    },
  );

  test('edits carry the version they were made on', () async {
    repository.receive(events.created('m1'));
    final medication = log().medication('m1')!;

    await actions().updateDetails(medication, details.copyWith(name: 'New'));
    await actions().updateDetails(medication, details.copyWith(name: 'Old'));

    expect(log().conflicts.single, isA<EditConflict>());
  });

  test('a schedule change keeps earlier doses on the old schedule', () async {
    repository.receive(events.created('m1', effectiveFrom: DateTime(2026, 11)));
    final medication = log().medication('m1')!;

    await actions().changeSchedule(
      medication,
      const DoseSchedule.fixed(minutesOfDay: [540]),
      effectiveFrom: DateTime(2026, 11, 3),
    );

    expect(log().medication('m1')?.slotsOn(DateTime(2026, 11, 2)), [
      DateTime(2026, 11, 2, 8),
      DateTime(2026, 11, 2, 20),
    ]);
    expect(log().medication('m1')?.slotsOn(DateTime(2026, 11, 3)), [
      DateTime(2026, 11, 3, 9),
    ]);
  });

  test('stock is recounted and refilled', () async {
    repository.receive(events.created('m1'));
    final medication = log().medication('m1')!;

    await actions().count(medication, 10);
    await actions().refill(medication, 28);

    expect(log().stockOf('m1')?.units, 38);
  });

  group('resolving an edit conflict', () {
    late MedicationUpdated anas;
    late MedicationUpdated martins;

    setUp(() {
      repository.receive(events.created('m1'));
      anas = events.updated('m1', baseVersion: 0, name: 'By Ana');
      martins = events.updated(
        'm1',
        baseVersion: 0,
        name: 'By Martín',
        by: 'martin',
      );
      repository
        ..receive(anas)
        ..receive(martins);
    });

    test('keeping the current version only marks it reviewed', () async {
      final conflict = log().conflicts.single as EditConflict;

      await actions().resolve(
        conflict,
        log().medication('m1')!,
        chosen: martins,
      );

      expect(log().conflicts, isEmpty);
      expect(log().medication('m1')?.details.name, 'By Martín');
    });

    test('choosing the other version applies it again', () async {
      final conflict = log().conflicts.single as EditConflict;

      await actions().resolve(conflict, log().medication('m1')!, chosen: anas);

      expect(log().conflicts, isEmpty);
      expect(log().medication('m1')?.details.name, 'By Ana');
    });
  });

  test('the detail lists recent doses newest first and its conflicts', () {
    final doses = [
      for (var hour = 1; hour <= recentDoseCount + 2; hour++)
        events.given('m1', at: DateTime(2026, 11, 2, hour)),
    ];
    final detail = buildMedicationDetail(
      CareLog([events.created('m1'), ...doses]),
      'm1',
    );

    expect(detail?.recentDoses, hasLength(recentDoseCount));
    expect(detail?.recentDoses.first, doses.last);
    expect(buildMedicationDetail(CareLog(const []), 'm1'), isNull);
  });
}
