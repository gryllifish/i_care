import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/domain/entities/care_event.dart';
import 'package:i_care/features/care/domain/entities/recipient_profile.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';
import 'package:i_care/shared/providers/phone_provider.dart';
import 'package:i_care/shared/widgets/labeled_field.dart';

import '../../../helpers/pump_app.dart';
import '../../../helpers/scrolling.dart';
import '../../care/helpers/care_events.dart';

void main() {
  final now = DateTime(2026, 11, 2, 12);
  late EventFactory events;
  late List<String> dialed;

  setUp(() {
    events = EventFactory();
    dialed = [];
  });

  Future<FakeCareRepository> open(
    WidgetTester tester, {
    RecipientProfile? profile,
  }) async {
    final repository = FakeCareRepository([
      events.created('m1'),
      if (profile != null) events.profile(profile),
    ])..status = SyncStatus(lastSyncedAt: now);
    await pumpApp(
      tester,
      repository: repository,
      now: now,
      overrides: [
        phoneCallerProvider.overrideWithValue((number) async {
          dialed.add(number);
          return true;
        }),
      ],
    );
    await tester.tap(find.text('Emergency card'));
    await tester.pumpAndSettle();
    return repository;
  }

  Finder list() => find.byType(Scrollable).first;

  testWidgets('shows allergies first and calls contacts', (tester) async {
    await open(
      tester,
      profile: RecipientProfile(
        name: 'Elena Rossi',
        birthDate: DateTime(1942, 3, 14),
        allergies: 'Penicillin',
        contacts: const [
          CareContact(name: 'Ana', role: 'Daughter', phone: '+54 11 5555'),
        ],
      ),
    );

    expect(find.text('Elena Rossi'), findsOneWidget);
    expect(find.text('Penicillin'), findsOneWidget);
    expect(find.text('Enalapril 10 mg'), findsOneWidget);

    final call = find.byTooltip('Call Ana');
    await centerInList(tester, call, list: list());
    await tester.tap(call);
    await tester.pumpAndSettle();

    expect(dialed, ['+54 11 5555']);
  });

  testWidgets('an empty card invites to fill it in', (tester) async {
    final repository = await open(tester);

    await tester.tap(find.text('Fill it in'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.descendant(
        of: find.ancestor(
          of: find.text('Full name'),
          matching: find.byType(LabeledField),
        ),
        matching: find.byType(TextField),
      ),
      'Elena',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final updated = repository.recorded.single as RecipientProfileUpdated;
    expect(updated.profile.name, 'Elena');
    expect(updated.baseVersion, 0);
    expect(find.text('No known allergies'), findsOneWidget);
  });

  testWidgets('the card fits at 200 % text size', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await open(
      tester,
      profile: const RecipientProfile(
        name: 'Elena Rossi',
        allergies: 'Penicillin',
        doctors: [
          CareContact(name: 'Dr. Pérez', role: 'Cardiology', phone: '+54'),
        ],
      ),
    );
    await tester.fling(list(), const Offset(0, -2000), 2000);
    await tester.pumpAndSettle();

    // Layout overflows fail the test on their own; nothing to assert.
  });
}
