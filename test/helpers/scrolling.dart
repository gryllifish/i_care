import 'package:flutter_test/flutter_test.dart';

/// Scrolls [list] until [finder] is built, then brings it to the middle,
/// so a tap never lands on the navigation bar at the bottom edge.
Future<void> centerInList(
  WidgetTester tester,
  Finder finder, {
  required Finder list,
}) async {
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(finder, 300, scrollable: list);
  }
  if (find.descendant(of: list, matching: finder).evaluate().isEmpty) return;
  // Part of each drag goes to the touch slop, so a few may be needed. A
  // drag shorter than the slop would count as a tap, so stop before.
  for (var attempt = 0; attempt < 3; attempt++) {
    final offset =
        tester.getRect(list).center.dy - tester.getCenter(finder.first).dy;
    if (offset.abs() <= kDragSlopDefault * 2) break;
    await tester.drag(list, Offset(0, offset));
    await tester.pumpAndSettle();
  }
}
