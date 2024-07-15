import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_wizard/utils/question.dart';
import 'package:test_wizard/widgets/assessment_data_editor.dart';
import 'package:test_wizard/widgets/question_set.dart';

void main() {
  group('Question Set', () {
    Future<List<Question>> fakeQuestionsFunction(String assessmentId) async {
      if (assessmentId == 'Test') {
        return [
          Question(
            questionId: 'testId',
            questionText: 'Test Question',
            answerText: 'Test Answer',
          ),
        ];
      } else {
        throw ArgumentError.value(assessmentId);
      }
    }

    test('correctly sets properties', () {
      QuestionSet qSet = QuestionSet(
        assessmentId: 'Test',
        future: fakeQuestionsFunction,
      );
      expect(qSet.future, fakeQuestionsFunction);
      expect(qSet.assessmentId, 'Test');
    });

    testWidgets('shows progress indicator before connecting', (tester) async {
      Widget app = MaterialApp(
        home: Scaffold(
          body: QuestionSet(
            assessmentId: 'Test',
            future: fakeQuestionsFunction,
          ),
        ),
      );
      await tester.pumpWidget(app);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('on error renders error message', (tester) async {
      Widget app = MaterialApp(
        home: Scaffold(
          body: QuestionSet(
            assessmentId: 'wrongId',
            future: fakeQuestionsFunction,
          ),
        ),
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      expect(find.text('Error: Invalid argument: "wrongId"'), findsOneWidget);
    });
    testWidgets('on success renders question set', (tester) async {
      Widget app = MaterialApp(
        home: Scaffold(
          body: QuestionSet(
            assessmentId: 'Test',
            future: fakeQuestionsFunction,
          ),
        ),
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Test Question'), findsOne);
      expect(find.text('Test Answer'), findsOne);
      expect(find.byType(IconRow), findsExactly(2));
    });
  });
}
