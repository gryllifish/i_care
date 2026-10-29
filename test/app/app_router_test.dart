import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/today/presentation/screens/today_screen.dart';

import '../helpers/pump_app.dart';

void main() {
  testWidgets('opens on Today', (tester) async {
    await pumpApp(tester);

    expect(find.byType(TodayScreen), findsOneWidget);
  });
}
