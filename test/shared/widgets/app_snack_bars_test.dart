import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/core/constants/app_durations.dart';
import 'package:i_care/shared/widgets/app_snack_bars.dart';

void main() {
  Future<ScaffoldMessengerState> pumpMessenger(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold()));
    return tester.state<ScaffoldMessengerState>(find.byType(ScaffoldMessenger));
  }

  testWidgets('a message with an action still goes away on its own', (
    tester,
  ) async {
    final messenger = await pumpMessenger(tester);
    messenger.showMessage(
      'Given',
      action: SnackBarAction(label: 'Undo', onPressed: () {}),
    );
    await tester.pumpAndSettle();
    expect(find.text('Given'), findsOneWidget);

    await tester.pump(AppDurations.message);
    await tester.pumpAndSettle();
    expect(find.text('Given'), findsNothing);
  });

  testWidgets('a message can be closed before it goes away', (tester) async {
    final messenger = await pumpMessenger(tester);
    messenger.showMessage('Saved');
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.text('Saved'), findsNothing);
  });

  testWidgets('an error stays until closed', (tester) async {
    final messenger = await pumpMessenger(tester);
    messenger.showError('No connection');
    await tester.pumpAndSettle();

    await tester.pump(const Duration(minutes: 1));
    await tester.pumpAndSettle();
    expect(find.text('No connection'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.text('No connection'), findsNothing);
  });
}
