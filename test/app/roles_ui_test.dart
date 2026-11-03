import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:i_care/core/config/demo_layout.dart';
import 'package:i_care/core/router/app_routes.dart';
import 'package:i_care/features/care/data/sample/sample_circle.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';
import 'package:i_care/features/settings/controllers/settings_controllers.dart';
import 'package:i_care/features/today/presentation/screens/today_screen.dart';
import 'package:i_care/shared/providers/device_prefs.dart';

import '../features/care/helpers/care_events.dart';
import '../helpers/pump_app.dart';

/// What each role is offered (`docs/roles.md`); the server checks every
/// event anyway.
void main() {
  final now = DateTime(2026, 11, 2, 9);
  final eight = DateTime(2026, 11, 2, 8);
  late EventFactory events;

  setUp(() => events = EventFactory());

  /// Enalapril at 08:00 and 20:00 from today, the sample members and
  /// Pablo, who
  /// only follows along.
  FakeCareRepository circle([List<CareEvent> extra = const []]) =>
      FakeCareRepository([
        ...SampleCircle.circleEvents(DateTime(2025)),
        events.memberInvited(
          'pablo',
          name: 'Pablo',
          role: MemberRole.viewer,
          at: DateTime(2025),
        ),
        events.memberJoined('pablo', at: DateTime(2025)),
        events.created('m1', effectiveFrom: DateTime(2026, 11, 2)),
        ...extra,
      ])..status = SyncStatus(lastSyncedAt: now);

  Future<void> pumpAs(
    WidgetTester tester,
    String memberId, [
    List<CareEvent> extra = const [],
  ]) => pumpApp(
    tester,
    repository: circle(extra),
    now: now,
    prefs: MemoryDevicePrefs({
      PrefKeys.welcomeSeen: 'true',
      PrefKeys.memberId: memberId,
    }),
  );

  Future<void> go(WidgetTester tester, String path) async {
    GoRouter.of(tester.element(find.byType(Scaffold).first)).go(path);
    await tester.pumpAndSettle();
  }

  group('an admin', () {
    testWidgets('sees how the day goes instead of the next dose to give', (
      tester,
    ) async {
      await pumpAs(tester, 'ana', [
        events.given('m1', at: eight, slotAt: eight, by: 'rosa'),
      ]);

      expect(find.text('TODAY SO FAR'), findsOneWidget);
      expect(find.text('Nothing late'), findsOneWidget);
      expect(
        find.text('Last: Rosa gave the 08:00 Enalapril, at 08:00.'),
        findsOneWidget,
      );
      expect(find.text('Mark as given'), findsNothing);
    });
  });

  group('a caregiver', () {
    testWidgets('gives from the next dose card, and cannot reset the demo', (
      tester,
    ) async {
      await pumpAs(tester, 'martin');

      expect(find.text('Mark as given'), findsOneWidget);
      expect(find.text('TODAY SO FAR'), findsNothing);

      await tester.tap(find.byTooltip('Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Reset sample data'), findsNothing);
      expect(find.text('Invite someone'), findsNothing);
    });
  });

  testWidgets('outside the demo even an admin is offered no demo reset', (
    tester,
  ) async {
    await pumpApp(
      tester,
      repository: circle(),
      now: now,
      prefs: MemoryDevicePrefs({
        PrefKeys.welcomeSeen: 'true',
        PrefKeys.memberId: 'ana',
      }),
      overrides: [isDemoProvider.overrideWithValue(false)],
    );

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('ABOUT'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Reset sample data'), findsNothing);
  });

  testWidgets('in the one-phone demo a caregiver can reset it, having no '
      'admin to ask', (tester) async {
    await pumpApp(
      tester,
      repository: circle(),
      now: now,
      prefs: MemoryDevicePrefs({
        PrefKeys.welcomeSeen: 'true',
        PrefKeys.memberId: 'martin',
      }),
      overrides: [demoLayoutProvider.overrideWithValue(DemoLayout.onePhone)],
    );

    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Reset sample data'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(
      find.text('Deletes everything recorded and loads the sample data again.'),
      findsOneWidget,
    );
    expect(find.text('Invite someone'), findsNothing);
  });

  group('a helper', () {
    testWidgets("has Today only: no tabs, and other tabs' routes lead back", (
      tester,
    ) async {
      await pumpAs(tester, 'rosa');

      expect(find.byType(NavigationBar), findsNothing);
      expect(find.text('Mark as given'), findsOneWidget);

      await go(tester, AppRoutes.medications);
      expect(find.byType(TodayScreen), findsOneWidget);
    });

    testWidgets('sees a double dose without the review, which others do', (
      tester,
    ) async {
      final anas = events.given('m1', at: eight, slotAt: eight);
      final rosas = events.given(
        'm1',
        at: eight.add(const Duration(minutes: 1)),
        slotAt: eight,
        by: 'rosa',
      );
      await pumpAs(tester, 'rosa', [anas, rosas]);

      // One to review opens straight into it.
      await tester.tap(find.text('1 thing to review'));
      await tester.pumpAndSettle();

      expect(
        find.text('An admin or a caregiver will review it.'),
        findsOneWidget,
      );
      expect(find.text('No, only one'), findsNothing);
    });
  });

  group('a viewer', () {
    testWidgets('sees the day and every tab, with nothing to change', (
      tester,
    ) async {
      await pumpAs(tester, 'pablo');

      expect(find.text('TODAY SO FAR'), findsOneWidget);
      expect(find.text('Mark as given'), findsNothing);

      await go(tester, AppRoutes.medications);
      expect(find.text('Enalapril'), findsOneWidget);
      expect(find.text('Add'), findsNothing);

      await go(tester, '${AppRoutes.medications}/m1');
      expect(find.byTooltip('More'), findsNothing);
      expect(find.text('Recount'), findsNothing);
    });

    testWidgets("with no notes this week still reaches the day's summary", (
      tester,
    ) async {
      await pumpAs(tester, 'pablo');

      final row = find.text('No notes this week');
      await tester.scrollUntilVisible(
        row,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(row);
      await tester.pumpAndSettle();

      expect(find.byTooltip("Copy the day's summary"), findsOneWidget);
      expect(find.byTooltip('Leave note'), findsNothing);
    });

    testWidgets('opens a dose to read it, without giving or skipping', (
      tester,
    ) async {
      await pumpAs(tester, 'pablo', [
        events.given('m1', at: eight, slotAt: eight),
      ]);

      // What is given folds into one line until opened.
      await tester.tap(find.text('1 done'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Enalapril 10 mg').first);
      await tester.pumpAndSettle();

      expect(find.text('Ana at 08:00'), findsWidgets);
      expect(find.text('Skip this dose'), findsNothing);
      expect(find.text('I gave it too'), findsNothing);
      expect(find.bySemanticsLabel("Remove Ana's record"), findsNothing);
    });
  });
}
