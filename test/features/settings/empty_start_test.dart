import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';
import 'package:i_care/features/settings/controllers/settings_controllers.dart';
import 'package:i_care/shared/providers/device_prefs.dart';

import '../../helpers/pump_app.dart';
import '../care/helpers/care_events.dart';

/// Trying the demo without its sample data, as on a first install.
void main() {
  final now = DateTime(2026, 11, 2, 9);
  late EventFactory events;

  setUp(() => events = EventFactory());

  FakeCareRepository sample() =>
      FakeCareRepository()..status = SyncStatus(lastSyncedAt: now);

  /// A circle of the user's own: Lucía cares for Abuela Rosa.
  FakeCareRepository ownCircle() => FakeCareRepository([
    CareEvent.circleCreated(
      meta: events.meta(at: DateTime(2026, 11), by: systemAuthor),
      recipientName: 'Abuela Rosa',
    ),
    events.memberInvited(
      'lucia',
      role: MemberRole.admin,
      by: systemAuthor,
      at: DateTime(2026, 11),
    ),
    events.memberJoined('lucia', at: DateTime(2026, 11)),
  ])..status = SyncStatus(lastSyncedAt: now);

  testWidgets('the welcome offers the sample or starting from scratch', (
    tester,
  ) async {
    var startedEmpty = 0;
    await pumpApp(
      tester,
      repository: sample(),
      now: now,
      prefs: MemoryDevicePrefs({PrefKeys.memberId: 'ana'}),
      overrides: [
        demoStartEmptyProvider.overrideWithValue(() async => startedEmpty++),
      ],
    );

    expect(find.text('Explore with sample data'), findsOneWidget);
    await tester.ensureVisible(find.text('Start from scratch'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start from scratch'));
    await tester.pumpAndSettle();
    expect(find.text('Start from scratch?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Start from scratch'));
    await tester.pumpAndSettle();

    expect(startedEmpty, 1);
  });

  testWidgets("one's own circle is welcomed plainly, without the demo choice", (
    tester,
  ) async {
    await pumpApp(
      tester,
      repository: ownCircle(),
      now: now,
      prefs: MemoryDevicePrefs({PrefKeys.memberId: 'lucia'}),
    );

    expect(find.text('Got it'), findsOneWidget);
    expect(find.text('Start from scratch'), findsNothing);
    expect(
      find.text('Everything here is sample data. Try it freely.'),
      findsNothing,
    );
  });

  testWidgets('a phone that belongs to nobody creates a circle', (
    tester,
  ) async {
    final membership = FakeMembershipRepository()..joinsAs = 'lucia';
    final prefs = MemoryDevicePrefs();
    await pumpApp(
      tester,
      repository: ownCircle(),
      now: now,
      prefs: prefs,
      membership: membership,
    );

    await tester.ensureVisible(find.text('Create a circle'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create a circle'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Create a circle'));
    await tester.pumpAndSettle();
    expect(find.text('Enter the name'), findsNWidgets(2));
    expect(membership.created, isEmpty);

    final fields = find.byType(TextField);
    await tester.enterText(fields.first, 'Lucía');
    await tester.enterText(fields.last, 'Abuela Rosa');
    await tester.tap(find.widgetWithText(FilledButton, 'Create a circle'));
    await tester.pumpAndSettle();

    expect(membership.created.single, (
      creatorName: 'Lucía',
      recipientName: 'Abuela Rosa',
    ));
    expect(prefs.read(PrefKeys.memberId), 'lucia');
    expect(find.text('Welcome to ICare'), findsOneWidget);
  });

  testWidgets('Today names the person cared for, with no sample label', (
    tester,
  ) async {
    await pumpApp(
      tester,
      repository: ownCircle(),
      now: now,
      prefs: MemoryDevicePrefs({
        PrefKeys.memberId: 'lucia',
        PrefKeys.welcomeSeen: 'true',
      }),
    );

    expect(find.text('Abuela Rosa'), findsOneWidget);
    expect(find.text('Sample data'), findsNothing);
  });
}
