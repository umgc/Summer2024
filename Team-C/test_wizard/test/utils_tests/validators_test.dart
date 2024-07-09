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

    test('checkOptionHasBeenSelected', () {
      String rejectString = 'Please select an option.';
      expect(Validators.checkOptionHasBeenSelected('Selectthis'), rejectString);
      expect(Validators.checkOptionHasBeenSelected('Select One of these'),
          rejectString);
      expect(Validators.checkOptionHasBeenSelected('Course 1'), null);
    });

    test('checkIsOneOrTwoDigits', () {
      String rejectString = 'Please enter one or two digits.';
      expect(Validators.checkIsOneOrTwoDigits(''), rejectString);
      expect(Validators.checkIsOneOrTwoDigits('12345'), rejectString);
      expect(Validators.checkIsOneOrTwoDigits('12'), null);
      expect(Validators.checkIsOneOrTwoDigits('1'), null);
    });
  });
}
