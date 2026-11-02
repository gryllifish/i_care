import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/features/care/controllers/task_actions.dart';
import 'package:i_care/features/care/data/care_providers.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/care_task.dart';
import 'package:i_care/features/care/domain/entities/conflict.dart';
import 'package:i_care/features/care/domain/entities/task_slot.dart';
import 'package:i_care/features/care/domain/projections/care_log.dart';
import 'package:i_care/shared/providers/clock_provider.dart';
import 'package:i_care/shared/providers/device_prefs.dart';
import 'package:i_care/shared/providers/id_provider.dart';

import '../../../helpers/pump_app.dart';
import '../helpers/care_events.dart';

void main() {
  final now = DateTime(2026, 11, 2, 9);
  final day = DateTime(2026, 11, 2);
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

  TaskActions actions() => container.read(taskActionsProvider.notifier);
  CareLog log() => CareLog(repository.events);

  test('creates a task with its times in order', () async {
    final result = await actions().create(
      details: const TaskDetails(name: 'Walk'),
      schedule: const TaskSchedule(minutesOfDay: [17 * 60, 10 * 60, 17 * 60]),
    );

    final id = (result as Ok<String>).value;
    expect(log().task(id)?.schedule.minutesOfDay, [10 * 60, 17 * 60]);
    expect(repository.recorded.single.meta.occurredAt, now);
  });

  test('edits and archives on the current version', () async {
    repository.events.add(events.task('t1'));
    await actions().update(
      log().task('t1')!,
      details: const TaskDetails(name: 'Shower'),
      schedule: const TaskSchedule(),
    );
    await actions().archive(log().task('t1')!);

    final archived = repository.recorded.last as TaskArchived;
    expect(archived.baseVersion, 1);
    expect(log().tasks, isEmpty);
    expect(log().conflicts, isEmpty);
  });

  test('records a task done or skipped, and takes a record back', () async {
    repository.events.add(events.task('t1', schedule: const TaskSchedule()));
    TaskSlot slot() => log().taskSlotsOn(day, now: now).single;

    final done = await actions().done(slot());
    expect(slot().status, TaskStatus.done);

    await actions().undo((done as Ok<TaskDone>).value);
    expect(slot().status, TaskStatus.due);

    await actions().skip(slot(), reasonId: SkipReason.unwell.id);
    expect(slot().skipped.single.reasonId, 'unwell');
  });

  test('resolving a concurrent edit applies the chosen one and marks it '
      'reviewed', () async {
    final anas = events.taskUpdated('t1', baseVersion: 0, name: 'Shower');
    repository.events.addAll([
      events.task('t1'),
      anas,
      events.taskUpdated('t1', baseVersion: 0, name: 'Bed bath', by: 'martin'),
    ]);
    final conflict = log().conflicts.single as EditConflict;

    await actions().resolve(conflict, log().task('t1')!, chosen: anas);

    expect(log().task('t1')?.details.name, 'Shower');
    expect(log().conflicts, isEmpty);
  });
}
