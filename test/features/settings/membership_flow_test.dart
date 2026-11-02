import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/core/error/failure.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';
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

  MemoryDevicePrefs phoneOf(String memberId) => MemoryDevicePrefs({
    PrefKeys.welcomeSeen: 'true',
    PrefKeys.memberId: memberId,
  });

  Future<void> openSettings(WidgetTester tester) async {
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
  }

  Future<void> tapInSettings(WidgetTester tester, Finder finder) async {
    await centerInList(tester, finder, list: find.byType(Scrollable).last);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets('a phone that belongs to nobody joins with a code', (
    tester,
  ) async {
    final prefs = MemoryDevicePrefs();
    await pumpApp(tester, repository: circle(), now: now, prefs: prefs);

    expect(find.text('Join a care circle'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'nope');
    await tester.tap(find.text('Join'));
    await tester.pumpAndSettle();
    expect(
      find.text('That code does not exist. Check it with whoever sent it.'),
      findsOneWidget,
    );

    await tester.enterText(find.byType(TextField), 'k7p-4qm');
    await tester.tap(find.text('Join'));
    await tester.pumpAndSettle();

    expect(prefs.read(PrefKeys.memberId), 'martin');
    expect(find.text('Welcome to ICare'), findsOneWidget);
  });

  testWidgets('an admin invites someone and gets their code', (tester) async {
    final repository = circle();
    final membership = FakeMembershipRepository();
    await pumpApp(
      tester,
      repository: repository,
      now: now,
      membership: membership,
    );
    await openSettings(tester);

    await tapInSettings(tester, find.text('Invite someone'));
    await tester.enterText(
      find.descendant(
        of: find.byType(BottomSheet),
        matching: find.byType(TextField),
      ),
      'Lucía',
    );
    await tester.tap(find.text('Helper').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.widgetWithText(FilledButton, 'Invite'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Invite'));
    await tester.pumpAndSettle();

    final invited = repository.recorded.single as MemberInvited;
    expect(invited.name, 'Lucía');
    expect(invited.role, MemberRole.helper);
    expect(membership.issuedFor, [invited.memberId]);
    expect(find.text('Code for Lucía'), findsOneWidget);
    expect(find.text(FakeMembershipRepository.validCode), findsOneWidget);
  });

  testWidgets("an admin changes someone's role and removes them", (
    tester,
  ) async {
    final repository = circle();
    await pumpApp(tester, repository: repository, now: now);
    await openSettings(tester);

    await tapInSettings(tester, find.text('Rosa'));
    await tester.tap(find.text('Caregiver').last);
    await tester.pumpAndSettle();
    final changed = repository.recorded.single as RoleChanged;
    expect(changed.memberId, 'rosa');
    expect(changed.role, MemberRole.caregiver);

    await tester.ensureVisible(find.text('Remove from the circle'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remove from the circle'));
    await tester.pumpAndSettle();
    expect(find.text('Remove Rosa from the circle?'), findsOneWidget);
    await tester.tap(
      find.widgetWithText(FilledButton, 'Remove from the circle'),
    );
    await tester.pumpAndSettle();

    expect(repository.recorded.last, isA<MemberRemoved>());
  });

  testWidgets('the last admin cannot be removed or lose the role', (
    tester,
  ) async {
    await pumpApp(tester, repository: circle(), now: now);
    await openSettings(tester);

    await tapInSettings(tester, find.text('Ana'));

    expect(find.text('The circle needs at least one admin.'), findsOneWidget);
    expect(find.text('Remove from the circle'), findsNothing);
  });

  testWidgets('only admins manage members', (tester) async {
    await pumpApp(
      tester,
      repository: circle(),
      now: now,
      prefs: phoneOf('martin'),
    );
    await openSettings(tester);

    expect(find.text('Invite someone'), findsNothing);
    await tapInSettings(tester, find.text('Rosa'));
    expect(find.text('Remove from the circle'), findsNothing);
  });

  testWidgets('leaving the circle asks first, then the phone joins anew', (
    tester,
  ) async {
    final prefs = phoneOf('martin');
    final membership = FakeMembershipRepository();
    await pumpApp(
      tester,
      repository: circle(),
      now: now,
      prefs: prefs,
      membership: membership,
    );
    await openSettings(tester);

    await tapInSettings(tester, find.text('Leave the circle on this phone'));
    await tester.tap(find.widgetWithText(FilledButton, 'Leave'));
    await tester.pumpAndSettle();

    expect(membership.left, 1);
    expect(prefs.read(PrefKeys.memberId), isNull);
    expect(find.text('Join a care circle'), findsOneWidget);
  });

  testWidgets('leaving offline says why and stays', (tester) async {
    final prefs = phoneOf('martin');
    await pumpApp(
      tester,
      repository: circle(),
      now: now,
      prefs: prefs,
      membership: FakeMembershipRepository()
        ..failure = const NoConnectionFailure(),
    );
    await openSettings(tester);

    await tapInSettings(tester, find.text('Leave the circle on this phone'));
    await tester.tap(find.widgetWithText(FilledButton, 'Leave'));
    await tester.pumpAndSettle();

    expect(
      find.text('Connect to leave: there are records still to send.'),
      findsOneWidget,
    );
    expect(prefs.read(PrefKeys.memberId), 'martin');
  });

  testWidgets('a removed phone says so, then clears and joins anew', (
    tester,
  ) async {
    final prefs = phoneOf('rosa');
    final membership = FakeMembershipRepository();
    await pumpApp(
      tester,
      repository: circle()
        ..status = SyncStatus(lastSyncedAt: now, isMember: false),
      now: now,
      prefs: prefs,
      membership: membership,
    );

    expect(find.text('This phone is out of the circle'), findsOneWidget);
    expect(find.byType(TodayScreen), findsNothing);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(membership.forgotten, 1);
    expect(prefs.read(PrefKeys.memberId), isNull);
    expect(find.text('Join a care circle'), findsOneWidget);
  });
}
