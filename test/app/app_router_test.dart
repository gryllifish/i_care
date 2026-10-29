import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/today/presentation/screens/today_screen.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('opens on Today', (tester) async {
    await pumpApp(
      tester,
      repository: FakeCareRepository(),
      now: DateTime(2026, 11, 2, 9),
    );

    expect(find.byType(TodayScreen), findsOneWidget);
  });
}
