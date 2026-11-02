import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/domain/entities/rejected_event.dart';
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

  testWidgets('the first run welcomes and shows whose phone this is', (
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
      find.text('This phone'),
      list: find.byType(Scrollable).first,
    );
    expect(find.text('Admin'), findsOneWidget);
    expect(find.text('Helper'), findsOneWidget);

    await tester.tap(find.text('Got it'));
    await tester.pumpAndSettle();

    expect(find.byType(TodayScreen), findsOneWidget);
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

  testWidgets('settings switch the theme and remember it', (tester) async {
    final prefs = MemoryDevicePrefs({PrefKeys.welcomeSeen: 'true'});
    await pumpApp(
      tester,
      repository: circle(),
      now: now,
      prefs: prefs,
    );

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark'), warnIfMissed: false);
    await tester.pumpAndSettle();

    final context = tester.element(find.text('Settings').first);
    expect(Theme.of(context).brightness, Brightness.dark);
    expect(prefs.read(PrefKeys.themeMode), 'dark');

    // The language has a System option too, above.
    await tester.tap(find.text('System').last, warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(prefs.read(PrefKeys.themeMode), isNull);
  });

  testWidgets('a saved theme is restored', (tester) async {
    await pumpApp(
      tester,
      repository: circle(),
      now: now,
      prefs: MemoryDevicePrefs({
        PrefKeys.welcomeSeen: 'true',
        PrefKeys.themeMode: 'dark',
      }),
    );

    final context = tester.element(find.byType(TodayScreen));
    expect(Theme.of(context).brightness, Brightness.dark);
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

  testWidgets('a refused record is flagged on Today and read in Settings', (
    tester,
  ) async {
    final refused = EventFactory().created('m2').withAuthor('ana');
    final repository = circle()
      ..rejected.add(
        RejectedEvent(event: refused, reason: RejectionReason.notAllowed),
      )
      ..status = SyncStatus(lastSyncedAt: now, rejectedCount: 1);
    await pumpApp(tester, repository: repository, now: now);

    expect(find.text('1 record not sent'), findsOneWidget);

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('NOT SENT'), findsOneWidget);
    expect(find.text('Ana added Enalapril'), findsOneWidget);
    expect(find.textContaining('Your role does not allow it.'), findsOneWidget);

    await tester.tap(find.text('Dismiss'));
    await tester.pumpAndSettle();
    expect(repository.rejected, isEmpty);
  });
}
