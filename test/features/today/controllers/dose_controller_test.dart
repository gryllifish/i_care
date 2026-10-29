import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/features/today/controllers/dose_controller.dart';

void main() {
  final now = DateTime(2026, 11, 2, 8, 30);

  test('latestAt is today when that time has passed', () {
    expect(latestAt(7, 15, now), DateTime(2026, 11, 2, 7, 15));
    expect(latestAt(8, 30, now), now);
  });

  test('latestAt is yesterday when that time has not come yet', () {
    expect(latestAt(21, 0, now), DateTime(2026, 11, 1, 21));
  });
}
