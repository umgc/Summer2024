import 'package:flutter_test/flutter_test.dart';
import 'package:test_wizard/utils/question.dart';

void main() {
  test('Question class correctly sets properties', () {
    String q1Id = 'q1';
    String q1Question = 'Why did the chicken cross the road?';
    String q1Answer = 'To get to the other side';
    String q2Id = 'q2';
    String q2Question = 'What is the meaning of life?';
    String q2Answer = '42';
    Question q1 = Question(
      questionId: q1Id,
      questionText: q1Question,
      answerText: q1Answer,
    );
    Question q2 = Question(
      questionId: q2Id,
      questionText: q2Question,
      answerText: q2Answer,
    );
    expect(q1.questionId, q1Id);
    expect(q2.questionId, q2Id);
    expect(q1.questionText, q1Question);
    expect(q2.questionText, q2Question);
    expect(q1.answerText, q1Answer);
    expect(q2.answerText, q2Answer);
  });
}
