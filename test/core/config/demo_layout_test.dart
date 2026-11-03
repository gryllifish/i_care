import 'package:flutter_test/flutter_test.dart';
import 'package:i_care/core/config/demo_layout.dart';

void main() {
  test('the demo shows two phones unless the address asks for one', () {
    DemoLayout of(String url) => DemoLayout.fromUri(Uri.parse(url));

    expect(of('https://example.com/i_care/'), DemoLayout.twoPhones);
    expect(of('https://example.com/i_care/?single'), DemoLayout.onePhone);
    expect(
      of('https://example.com/i_care/?single#/medications'),
      DemoLayout.onePhone,
    );
  });
}
