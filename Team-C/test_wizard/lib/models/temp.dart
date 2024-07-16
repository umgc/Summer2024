import 'package:test_wizard/utils/question.dart';

class TempModel {
  static Future<List<String>> fetchDropdownOptions(String optionName) async {
    switch (optionName) {
      case 'Course':
        return ['Select Course', 'Course 1', 'Course 2'];
      case 'Assessment Type':
        return [
          'Select Assessment Type',
          'Short Answer',
          'Multiple Choice',
          'Essay'
        ];
      case 'Graded On':
        return [
          'Select Graded On',
          'Standards Based Grading',
          'Points Based Grading'
        ];
      default:
        throw ArgumentError.value(optionName);
    }
  }

  static Future<List<Question>> fetchQuestions(
    String assessmentId,
  ) async {
    // basically this fetch will either fetch the test from local storage or from the moodle
    // we will have to change this later.
    switch (assessmentId) {
      case 'TestingAssessment':
        return [
          Question(
              questionId: 'question1',
              questionText: 'Solve the equation 2x - 7 = 11',
              answerText: 'x = 3')
        ];
      case 'MQ1V1':
        return [
          Question(
            questionId: 'question1',
            questionText: 'Solve the equation: 3x - 7 = 11',
            answerText: 'x = 6',
          ),
          Question(
            questionId: 'question2',
            questionText: 'Factor the quadratic equation: x^2 - 5x + 6 = 0',
            answerText: '(x - 2)(x - 3) = 0',
          ),
          Question(
            questionId: 'question3',
            questionText:
                'What is the slope of the line that passes through the points (2, 3) and (4, 7)?',
            answerText: 'Slope = 2',
          ),
          Question(
            questionId: 'question4',
            questionText: 'Evaluate the expression: 2(3x - 4) when x = 5',
            answerText: '22',
          ),
          Question(
            questionId: 'question5',
            questionText: 'Simplify the expression: 5x - 2(x - 3)',
            answerText: '3x + 6',
          ),
        ];
      default:
        throw ArgumentError.value(assessmentId);
    }
  }
}
