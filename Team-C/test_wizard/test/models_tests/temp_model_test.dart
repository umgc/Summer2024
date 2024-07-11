import 'package:flutter_test/flutter_test.dart';
import 'package:test_wizard/models/temp.dart';

void main() {
  group('Temp Model', () {
    test('fetchDropdownOptions', () async {
      expect(
        await TempModel.fetchDropdownOptions('Course'),
        ['Select Course', 'Course 1', 'Course 2'],
      );
      expect(
        await TempModel.fetchDropdownOptions('Assessment Type'),
        ['Select Assessment Type', 'Short Answer', 'Multiple Choice', 'Essay'],
      );
      expect(
        await TempModel.fetchDropdownOptions('Graded On'),
        ['Select Graded On', 'Standards Based Grading', 'Points Based Grading'],
      );
      expect(() => TempModel.fetchDropdownOptions('anything else'),
          throwsArgumentError);
      expect(() => TempModel.fetchDropdownOptions(''), throwsArgumentError);
    });
  });
}
