import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';
import 'package:i_care/features/settings/controllers/settings_controllers.dart';
import 'package:i_care/features/today/presentation/screens/today_screen.dart';
import 'package:i_care/shared/providers/device_prefs.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/scrolling.dart';
import '../care/helpers/care_events.dart';

void main() {
  final now = DateTime(2026, 11, 2, 9);

  FakeCareRepository circle() => FakeCareRepository([
    EventFactory().created('m1'),
  ])..status = SyncStatus(lastSyncedAt: now);

  testWidgets('the first run welcomes and asks who uses the phone', (
    tester,
  ) async {
    final prefs = MemoryDevicePrefs();
    await pumpApp(
      tester,
      repository: circle(),
      now: now,
      prefs: prefs,
    );

    expect(find.text('Welcome to ICare'), findsOneWidget);
    expect(find.byType(TodayScreen), findsNothing);

    await centerInList(
      tester,
      find.text('Martín'),
      list: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Martín'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Got it'));
    await tester.pumpAndSettle();

    expect(find.byType(TodayScreen), findsOneWidget);
    expect(prefs.read(PrefKeys.caregiverId), 'martin');
    expect(prefs.read(PrefKeys.welcomeSeen), 'true');
  });

  testWidgets('settings switch the language and remember it', (tester) async {
    final prefs = MemoryDevicePrefs({PrefKeys.welcomeSeen: 'true'});
    await pumpApp(
      tester,
      repository: circle(),
      now: now,
      prefs: prefs,
    );

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Español'), warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.text('Ajustes'), findsOneWidget);
    expect(prefs.read(PrefKeys.language), 'es');
  });

  testWidgets('resetting the demo asks first', (tester) async {
    var resets = 0;
    await pumpApp(
      tester,
      repository: circle(),
      now: now,
      overrides: [
        demoResetProvider.overrideWithValue(() async => resets++),
      ],
    );

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    final reset = find.text('Reset sample data');
    await tester.scrollUntilVisible(
      reset,
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(reset);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Reset'));
    await tester.pumpAndSettle();

    expect(resets, 1);
    expect(find.text('Sample data loaded again'), findsOneWidget);
  });
}
