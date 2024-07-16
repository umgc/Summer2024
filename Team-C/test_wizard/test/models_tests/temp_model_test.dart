import 'package:flutter_test/flutter_test.dart';
import 'package:test_wizard/models/temp.dart';
import 'package:test_wizard/utils/question.dart';

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
      expect(() => TempModel.fetchDropdownOptions('anything else'),
          throwsArgumentError);
      expect(() => TempModel.fetchDropdownOptions(''), throwsArgumentError);
    });

    test('fetchQuestions', () async {
      List<Question> list = await TempModel.fetchQuestions('TestingAssessment');
      expect(
        list[0].questionId,
        'question1',
        reason:
            "Check that this method isn't returning default information if you aren't expecting it",
      );
      expect(
        list[0].questionText,
        'Solve the equation 2x - 7 = 11',
        reason:
            "Check that this method isn't returning default information if you aren't expecting it",
      );
      expect(
        list[0].answerText,
        'x = 3',
        reason:
            "Check that this method isn't returning default information if you aren't expecting it",
      );
      List<Question> list2 = await TempModel.fetchQuestions('MQ1V1');

      expect(
        list2.length,
        5,
        reason:
            "Check that this method isn't returning default information if you aren't expecting it",
      );
      expect(
        list2[0].questionId,
        'question1',
        reason:
            "Check that this method isn't returning default information if you aren't expecting it",
      );
      expect(
        list2[4].questionId,
        'question5',
        reason:
            "Check that this method isn't returning default information if you aren't expecting it",
      );
      expect(
        list2[4].answerText,
        '3x + 6',
        reason:
            "Check that this method isn't returning default information if you aren't expecting it",
      );
      expect(() => TempModel.fetchQuestions('wrongId'), throwsArgumentError);
      expect(() => TempModel.fetchQuestions(''), throwsArgumentError);
    });
  });
}
