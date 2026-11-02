import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/app/app.dart';
import 'package:i_care/core/error/failure.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/features/care/data/care_providers.dart';
import 'package:i_care/features/care/data/sample/sample_circle.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/rejected_event.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';
import 'package:i_care/features/care/domain/repositories/care_repository.dart';
import 'package:i_care/shared/providers/clock_provider.dart';
import 'package:i_care/shared/providers/device_prefs.dart';
import 'package:i_care/shared/providers/id_provider.dart';

/// An in-memory log; recorded events stay pending, as on a phone that
/// has not synced them yet.
class FakeCareRepository implements CareRepository {
  /// Holds [events], after the sample circle's members unless [events]
  /// brings members of its own: screens name people from the log.
  FakeCareRepository([List<CareEvent> events = const []])
    : events = [
        if (!events.any((event) => event is MemberInvited))
          ...SampleCircle.memberEvents(DateTime(2025)),
        ...events,
      ];

  final List<CareEvent> events;
  final _changes = StreamController<void>.broadcast();

  /// When set, recording fails with it.
  Failure? failure;

  SyncStatus status = SyncStatus(lastSyncedAt: DateTime(2026));

  /// Events recorded through the app, in order.
  final recorded = <CareEvent>[];

  /// Events the server refused, as the repository reports them.
  final rejected = <RejectedEvent>[];

  @override
  Stream<List<CareEvent>> watchEvents() async* {
    yield List.of(events);
    await for (final _ in _changes.stream) {
      yield List.of(events);
    }
  }

  @override
  Future<Result<void>> record(CareEvent event) async {
    if (failure case final Failure failure) return Err(failure);
    events.add(event);
    recorded.add(event);
    _changes.add(null);
    return const Ok<void>(null);
  }

  /// Adds [event] as if it had arrived from another phone.
  void receive(CareEvent event) {
    events.add(event);
    _changes.add(null);
  }

  @override
  Stream<SyncStatus> watchSyncStatus() => Stream.value(status);

  @override
  Stream<List<RejectedEvent>> watchRejected() => Stream.value(rejected);

  @override
  Future<Result<void>> dismissRejected(String eventId) async {
    rejected.removeWhere((item) => item.event.meta.id == eventId);
    return const Ok(null);
  }
}

/// Logical size of a typical phone.
const phoneSize = Size(393, 852);

/// Pumps one phone's app (real router and screens) on [repository], at
/// [now], with predictable event ids.
Future<void> pumpApp(
  WidgetTester tester, {
  required FakeCareRepository repository,
  required DateTime now,
  Size size = phoneSize,
  List<Override> overrides = const [],

  /// This phone's preferences; by default, past the welcome.
  DevicePrefs? prefs,
}) async {
  tester.view
    ..physicalSize = size * 3
    ..devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  var nextId = 0;
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        careRepositoryProvider.overrideWithValue(repository),
        clockProvider.overrideWithValue(() => now),
        newIdProvider.overrideWithValue(() => 'new-${nextId++}'),
        devicePrefsProvider.overrideWithValue(
          prefs ?? MemoryDevicePrefs({PrefKeys.welcomeSeen: 'true'}),
        ),
        ...overrides,
      ],
      // Riverpod retries failed providers by default; tests want the raw
      // error on screen.
      retry: (_, _) => null,
      child: const App(),
    ),
  );
  await tester.pumpAndSettle();
}
