import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/core/error/failure.dart';
import 'package:i_care/core/utils/formatters.dart';
import 'package:i_care/features/care/data/sample/sample_circle.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/member.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';
import 'package:i_care/shared/providers/device_prefs.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/scrolling.dart';
import '../care/helpers/care_events.dart';

void main() {
  final now = DateTime(2026, 11, 2, 9);
  late EventFactory events;

  setUp(() => events = EventFactory());

  FakeCareRepository circle([List<CareEvent> extra = const []]) =>
      FakeCareRepository([events.created('m1'), ...extra])
        ..status = SyncStatus(lastSyncedAt: now);

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

  test('an email is shown masked', () {
    expect(Formatters.maskedEmail('ana@example.com'), 'a•••@example.com');
    expect(Formatters.maskedEmail('not an email'), 'not an email');
  });

  group('protecting access in Settings', () {
    testWidgets('links the Google account picked and shows it masked', (
      tester,
    ) async {
      final access = FakeAccessRepository();
      await pumpApp(
        tester,
        repository: circle(),
        now: now,
        prefs: phoneOf('martin'),
        access: access,
      );
      await openSettings(tester);

      await tapInSettings(tester, find.text('Protect with Google'));

      expect(access.protectedBy, 'ana@example.com');
      expect(
        find.text('Access protected with a•••@example.com'),
        findsOneWidget,
      );
      expect(find.text('Protect with Google'), findsNothing);
    });

    testWidgets('closing the picker changes nothing and shows no error', (
      tester,
    ) async {
      await pumpApp(
        tester,
        repository: circle(),
        now: now,
        prefs: phoneOf('ana'),
        access: FakeAccessRepository()..account = null,
      );
      await openSettings(tester);

      await tapInSettings(tester, find.text('Protect with Google'));

      expect(find.text('Protect with Google'), findsOneWidget);
      expect(find.textContaining('protected with'), findsNothing);
    });

    testWidgets('an account protecting another access is refused', (
      tester,
    ) async {
      await pumpApp(
        tester,
        repository: circle(),
        now: now,
        prefs: phoneOf('ana'),
        access: FakeAccessRepository()..failure = const AccountInUseFailure(),
      );
      await openSettings(tester);

      await tapInSettings(tester, find.text('Protect with Google'));

      expect(
        find.text('That Google account already protects another access.'),
        findsOneWidget,
      );
    });

    testWidgets('says so when Google cannot hand over an account', (
      tester,
    ) async {
      await pumpApp(
        tester,
        repository: circle(),
        now: now,
        prefs: phoneOf('ana'),
        access: FakeAccessRepository()..failure = const GoogleSignInFailure(),
      );
      await openSettings(tester);

      await tapInSettings(tester, find.text('Protect with Google'));

      expect(
        find.text(
          'Could not sign in with Google. Check that this phone has a '
          'Google account, then try again.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('is not offered where there is no Google sign-in', (
      tester,
    ) async {
      await pumpApp(
        tester,
        repository: circle(),
        now: now,
        prefs: phoneOf('ana'),
      );
      await openSettings(tester);

      expect(find.text('YOUR ACCESS'), findsNothing);
      expect(find.text('Protect with Google'), findsNothing);
    });
  });

  group('a phone that belongs to nobody', () {
    testWidgets('gets back in with the Google account protecting an access', (
      tester,
    ) async {
      await pumpApp(
        tester,
        repository: circle(),
        now: now,
        prefs: MemoryDevicePrefs(),
        access: FakeAccessRepository()..recoversAs = 'ana',
      );

      await tester.tap(find.text('I already have access'));
      await tester.pumpAndSettle();

      expect(find.text('Welcome to ICare'), findsOneWidget);
      // Already protected, so the welcome does not ask again.
      await tester.scrollUntilVisible(
        find.text('Access protected with a•••@example.com'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Protect with Google'), findsNothing);
    });

    testWidgets('is told when the account protects no access', (tester) async {
      await pumpApp(
        tester,
        repository: circle(),
        now: now,
        prefs: MemoryDevicePrefs(),
        access: FakeAccessRepository(),
      );

      await tester.tap(find.text('I already have access'));
      await tester.pumpAndSettle();

      expect(
        find.text(
          'No access is protected with that Google account. Ask an admin '
          'of the circle for a code.',
        ),
        findsOneWidget,
      );
      expect(find.text('Join a care circle'), findsOneWidget);
    });

    testWidgets('is not offered it where there is no Google sign-in', (
      tester,
    ) async {
      await pumpApp(
        tester,
        repository: circle(),
        now: now,
        prefs: MemoryDevicePrefs(),
      );

      expect(find.text('Join a care circle'), findsOneWidget);
      expect(find.text('I already have access'), findsNothing);
    });
  });

  group('the welcome', () {
    for (final (who, memberId, asked) in [
      ('an admin', 'ana', true),
      ('a caregiver', 'martin', false),
    ]) {
      testWidgets('${asked ? 'asks' : 'does not ask'} $who to protect '
          'their access', (tester) async {
        await pumpApp(
          tester,
          repository: circle(),
          now: now,
          prefs: MemoryDevicePrefs({PrefKeys.memberId: memberId}),
          access: FakeAccessRepository(),
        );

        expect(find.text('Welcome to ICare'), findsOneWidget);
        final button = find.text('Protect with Google');
        if (asked) {
          await tester.scrollUntilVisible(
            button,
            200,
            scrollable: find.byType(Scrollable).first,
          );
        }
        expect(button, asked ? findsOneWidget : findsNothing);
      });
    }
  });

  group('a circle with one admin', () {
    const hint =
        'You are the only admin. If you could not use this phone, nobody '
        'else could invite people or give out codes. Consider making '
        'someone else an admin too.';

    testWidgets('suggests a second one to its admin', (tester) async {
      await pumpApp(
        tester,
        repository: circle(),
        now: now,
        prefs: phoneOf('ana'),
      );
      await openSettings(tester);

      expect(find.text(hint), findsOneWidget);
    });

    testWidgets('says nothing to who cannot change it', (tester) async {
      await pumpApp(
        tester,
        repository: circle(),
        now: now,
        prefs: phoneOf('martin'),
      );
      await openSettings(tester);

      expect(find.text(hint), findsNothing);
    });

    testWidgets('still suggests it while the second has no phone yet', (
      tester,
    ) async {
      await pumpApp(
        tester,
        repository: circle([
          // The sample members, and an admin invited but not joined.
          ...SampleCircle.circleEvents(DateTime(2025)),
          events.memberInvited('lucia', role: MemberRole.admin),
        ]),
        now: now,
        prefs: phoneOf('ana'),
      );
      await openSettings(tester);

      expect(find.text(hint), findsOneWidget);
    });

    testWidgets('stops suggesting once there are two', (tester) async {
      await pumpApp(
        tester,
        repository: circle([
          events.roleChanged('martin', MemberRole.admin, baseVersion: 0),
        ]),
        now: now,
        prefs: phoneOf('ana'),
      );
      await openSettings(tester);

      expect(find.text(hint), findsNothing);
    });
  });
}
