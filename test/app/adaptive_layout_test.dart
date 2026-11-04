import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/core/constants/app_layout.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';
import 'package:i_care/features/settings/presentation/screens/settings_screen.dart';
import 'package:i_care/features/today/presentation/screens/today_screen.dart';

import '../features/care/helpers/care_events.dart';
import '../helpers/pump_app.dart';

/// The same design on any width: tabs at the bottom on a phone, at the
/// side on a wide screen, and content in a readable column.
void main() {
  final now = DateTime(2026, 11, 2, 9);

  Future<void> pumpAt(WidgetTester tester, Size size) => pumpApp(
    tester,
    size: size,
    repository: FakeCareRepository([
      EventFactory().created('m1', effectiveFrom: DateTime(2026, 11, 2)),
    ])..status = SyncStatus(lastSyncedAt: now),
    now: now,
  );

  testWidgets('a phone keeps the tabs at the bottom', (tester) async {
    await pumpAt(tester, const Size(393, 852));

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });

  testWidgets('a wide screen moves them to the side, content in a column', (
    tester,
  ) async {
    await pumpAt(tester, const Size(1440, 900));

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    expect(
      tester.getSize(find.byType(TodayScreen)).width,
      AppLayout.contentMaxWidth,
    );

    await tester.tap(find.text('Meds'));
    await tester.pumpAndSettle();
    expect(find.text('Enalapril'), findsWidgets);
  });

  testWidgets('screens outside the tabs keep the column too', (tester) async {
    await pumpAt(tester, const Size(1440, 900));

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();

    expect(
      tester.getSize(find.byType(SettingsScreen)).width,
      AppLayout.contentMaxWidth,
    );
  });

  testWidgets('the side tabs fit text at 200%', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await pumpAt(tester, const Size(1280, 720));

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
