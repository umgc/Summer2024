import 'package:flutter_test/flutter_test.dart';
import 'package:test_wizard/utils/example.dart';

void main() {
  test('addTwoPlusTwo returns 4', () {
    var result = addTwoPlusTwo();
    expect(result, 4);
  });
}
