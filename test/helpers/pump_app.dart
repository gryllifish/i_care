import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/app/app.dart';

/// Logical size of a typical phone.
const phoneSize = Size(393, 852);

/// Pumps the whole app (real router and screens) at a logical [size] that
/// defaults to a phone.
Future<void> pumpApp(WidgetTester tester, {Size size = phoneSize}) async {
  tester.view
    ..physicalSize = size * 3
    ..devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    // Riverpod retries failed providers by default; tests want the raw
    // error on screen.
    ProviderScope(retry: (_, _) => null, child: const App()),
  );
  await tester.pumpAndSettle();
}
