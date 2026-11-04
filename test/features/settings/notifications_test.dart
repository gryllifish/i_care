import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/core/error/failure.dart';
import 'package:i_care/core/error/result.dart';
import 'package:i_care/features/care/data/care_providers.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';
import 'package:i_care/features/care/domain/repositories/push_repository.dart';
import 'package:i_care/shared/providers/device_prefs.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/scrolling.dart';
import '../care/helpers/care_events.dart';

/// Answers like Firebase and the server would; [failure] makes it refuse.
class _FakePush implements PushRepository {
  Failure? failure;
  final enabledIn = <String>[];
  int disabled = 0;

  @override
  Future<Result<void>> enable({required String language}) async {
    if (failure case final Failure failure) return Err(failure);
    enabledIn.add(language);
    return const Ok(null);
  }

  @override
  Future<Result<void>> refresh({required String language}) async =>
      const Ok(null);

  @override
  Future<Result<void>> disable() async {
    disabled++;
    return const Ok(null);
  }
}

void main() {
  final now = DateTime(2026, 11, 2, 9);
  const switchLabel = "Tell me about the circle's news";

  Future<MemoryDevicePrefs> openSettings(
    WidgetTester tester, {
    _FakePush? push,
  }) async {
    final prefs = MemoryDevicePrefs({
      PrefKeys.welcomeSeen: 'true',
      PrefKeys.memberId: 'ana',
    });
    await pumpApp(
      tester,
      repository: FakeCareRepository([EventFactory().created('m1')])
        ..status = SyncStatus(lastSyncedAt: now),
      now: now,
      prefs: prefs,
      overrides: [pushRepositoryProvider.overrideWithValue(push)],
    );
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    return prefs;
  }

  testWidgets('are not offered where the build has none', (tester) async {
    await openSettings(tester);

    expect(find.text(switchLabel), findsNothing);
  });

  testWidgets('turn on in the app language, and off again', (tester) async {
    final push = _FakePush();
    final prefs = await openSettings(tester, push: push);
    final toggle = find.text(switchLabel);
    await centerInList(tester, toggle, list: find.byType(Scrollable).last);

    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(push.enabledIn, ['en']);
    expect(prefs.read(PrefKeys.notifications), 'true');

    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(push.disabled, 1);
    expect(prefs.read(PrefKeys.notifications), isNull);
  });

  testWidgets('blocked notifications say how to allow them, and stay off', (
    tester,
  ) async {
    final push = _FakePush()..failure = const NotificationsBlockedFailure();
    final prefs = await openSettings(tester, push: push);
    final toggle = find.text(switchLabel);
    await centerInList(tester, toggle, list: find.byType(Scrollable).last);

    await tester.tap(toggle);
    await tester.pumpAndSettle();

    expect(
      find.text(
        "Notifications are blocked for ICare. Allow them in this device's "
        'settings, then try again.',
      ),
      findsOneWidget,
    );
    expect(prefs.read(PrefKeys.notifications), isNull);
    expect(
      tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
      isFalse,
    );
  });
}
