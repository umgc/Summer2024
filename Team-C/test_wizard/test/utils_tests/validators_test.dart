import 'package:flutter_test/flutter_test.dart';
import 'package:test_wizard/utils/validators.dart';

void main() {
  group('Validators class', () {
    test('checkIsEmpty', () {
      String rejectString = 'This field cannot be blank.';
      expect(Validators.checkIsEmpty(""), rejectString);
      expect(Validators.checkIsEmpty(" "), rejectString);
      expect(Validators.checkIsEmpty(null), rejectString);
      expect(Validators.checkIsEmpty("SWEN"), null);
    });

    test('checkOptionHasBeenSelected', () {});

    test('checkIsOneOrTwoDigits', () {});
  });
}
