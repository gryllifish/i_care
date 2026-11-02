import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/care/domain/entities/sync_status.dart';

import '../../../helpers/pump_app.dart';
import '../../care/helpers/care_events.dart';

void main() {
  final now = DateTime(2026, 11, 2, 9);

  testWidgets("flags a former member's record and names who joined", (
    tester,
  ) async {
    final events = EventFactory();
    final late = events.given('m1', at: DateTime(2026, 11, 2, 8), by: 'rosa');
    await pumpApp(
      tester,
      repository: FakeCareRepository([
        events.created('m1', at: DateTime(2026, 11)),
        late.copyWith(
          meta: late.meta.copyWith(receivedAt: now, fromFormerMember: true),
        ),
      ])..status = SyncStatus(lastSyncedAt: now),
      now: now,
    );

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Activity'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Rosa gave Enalapril'), findsOneWidget);
    expect(find.text('After their access ended'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Rosa joined the circle'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
  });
}
