import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/activity/presentation/screens/activity_screen.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';
import 'package:i_care/features/medications/presentation/screens/medications_screen.dart';
import 'package:i_care/features/today/presentation/screens/today_screen.dart';

import '../features/care/helpers/care_events.dart';
import '../helpers/pump_app.dart';

void main() {
  final now = DateTime(2026, 11, 2, 9);

  Future<void> pump(WidgetTester tester) {
    final events = EventFactory();
    return pumpApp(
      tester,
      repository: FakeCareRepository([
        events.created('m1', at: DateTime(2026, 11)),
        events.counted('m1', 30, at: DateTime(2026, 11)),
        events.given(
          'm1',
          at: DateTime(2026, 11, 2, 8, 4),
          slotAt: DateTime(2026, 11, 2, 8),
        ),
      ])..status = SyncStatus(lastSyncedAt: now),
      now: now,
    );
  }

  testWidgets('opens on Today', (tester) async {
    await pump(tester);

    expect(find.byType(TodayScreen), findsOneWidget);
  });

  testWidgets('the navigation bar switches between the tabs', (tester) async {
    await pump(tester);

    Finder tab(String label) => find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text(label),
    );

    await tester.tap(tab('Medications'));
    await tester.pumpAndSettle();
    expect(find.byType(MedicationsScreen), findsOneWidget);
    expect(find.text('1 active medication · Sample data'), findsOneWidget);
    expect(find.text('08:00 · 20:00 · Every day'), findsOneWidget);
    expect(find.text('29 units'), findsOneWidget);

    await tester.tap(tab('Activity'));
    await tester.pumpAndSettle();
    expect(find.byType(ActivityScreen), findsOneWidget);
    expect(find.text('Ana gave the 08:00 Enalapril'), findsOneWidget);

    await tester.tap(tab('Today'));
    await tester.pumpAndSettle();
    expect(find.byType(TodayScreen), findsOneWidget);
  });

  testWidgets('every tab fits at 200 % text size', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await pump(tester);

    for (final label in ['Medications', 'Activity', 'Today']) {
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text(label),
        ),
      );
      await tester.pumpAndSettle();
      await tester.fling(
        find.byType(Scrollable).first,
        const Offset(0, -2000),
        2000,
      );
      await tester.pumpAndSettle();
    }

    // Layout overflows fail the test on their own; nothing to assert.
  });
}
