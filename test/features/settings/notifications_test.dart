import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/features/care/data/care_providers.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';
import 'package:i_care/features/care/domain/repositories/push_repository.dart';
import 'package:i_care/shared/providers/device_prefs.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/scrolling.dart';
import '../care/helpers/care_events.dart';

/// The system and the server as the app sees them: [current] is the
/// system's answer so far; its dialog would say yes.
class _FakePush implements PushRepository {
  _FakePush(this.current);

  PushPermission current;
  int asked = 0;
  final syncedIn = <String>[];

  @override
  Future<Result<PushPermission>> permission() async => Ok(current);

  @override
  Future<Result<PushPermission>> request({required String language}) async {
    asked++;
    if (current == PushPermission.notAsked) current = PushPermission.allowed;
    return Ok(current);
  }

  @override
  Future<Result<PushPermission>> sync({required String language}) async {
    syncedIn.add(language);
    return Ok(current);
  }
}

void main() {
  final now = DateTime(2026, 11, 2, 9);
  const turnOn = 'Turn on notifications';

  /// A circle of the family's own, not the demo's sample: what the beta,
  /// the only build with push, always has.
  FakeCareRepository circle() {
    final events = EventFactory();
    return FakeCareRepository([
      CareEvent.circleCreated(
        meta: events.meta(at: DateTime(2026), by: 'system'),
        recipientName: 'Elena',
      ),
      events.memberInvited('ana', name: 'Ana', role: MemberRole.admin),
      events.memberJoined('ana'),
      events.created('m1'),
    ])..status = SyncStatus(lastSyncedAt: now);
  }

  Future<void> pump(
    WidgetTester tester,
    _FakePush? push, {
    bool welcomeSeen = true,
  }) => pumpApp(
    tester,
    repository: circle(),
    now: now,
    prefs: MemoryDevicePrefs({
      if (welcomeSeen) PrefKeys.welcomeSeen: 'true',
      PrefKeys.memberId: 'ana',
    }),
    overrides: [pushRepositoryProvider.overrideWithValue(push)],
  );

  Future<void> openSettings(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    await centerInList(
      tester,
      find.text('NOTIFICATIONS'),
      list: find.byType(Scrollable).last,
    );
  }

  testWidgets('starting from the welcome asks the system, once, having '
      'said so', (tester) async {
    final push = _FakePush(PushPermission.notAsked);
    await pump(tester, push, welcomeSeen: false);

    expect(find.textContaining('ICare will ask to notify you'), findsOneWidget);
    await tester.tap(find.text('Got it'));
    await tester.pumpAndSettle();

    expect(push.asked, 1);
    expect(push.current, PushPermission.allowed);
  });

  testWidgets('a phone already answered is not asked again on starting', (
    tester,
  ) async {
    final push = _FakePush(PushPermission.denied);
    await pump(tester, push, welcomeSeen: false);

    expect(find.textContaining('ICare will ask to notify you'), findsNothing);
    await tester.tap(find.text('Got it'));
    await tester.pumpAndSettle();

    expect(push.asked, 0);
  });

  testWidgets('the app keeps the token by itself on start', (tester) async {
    final push = _FakePush(PushPermission.allowed);
    await pump(tester, push);

    expect(push.syncedIn, ['en']);
  });

  testWidgets('Settings shows that notifications are on, with no switch', (
    tester,
  ) async {
    await pump(tester, _FakePush(PushPermission.allowed));
    await openSettings(tester);

    expect(find.text('Notifications are on.'), findsOneWidget);
    expect(find.text(turnOn), findsNothing);
    expect(find.byType(Switch), findsNothing);
  });

  testWidgets('Settings says where to turn them on once refused', (
    tester,
  ) async {
    await pump(tester, _FakePush(PushPermission.denied));
    await openSettings(tester);

    expect(
      find.text(
        "Notifications are off. You can turn them on in this device's "
        'settings.',
      ),
      findsOneWidget,
    );
    expect(find.text(turnOn), findsNothing);
  });

  testWidgets('Settings offers turning them on while never asked', (
    tester,
  ) async {
    final push = _FakePush(PushPermission.notAsked);
    await pump(tester, push);
    await openSettings(tester);

    await tester.tap(find.text(turnOn));
    await tester.pumpAndSettle();

    expect(push.asked, 1);
    expect(find.text('Notifications are on.'), findsOneWidget);
  });

  testWidgets('builds without push show nothing about them', (tester) async {
    await pump(tester, null);
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('NOTIFICATIONS'), findsNothing);
  });
}
