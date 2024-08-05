import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_wizard/widgets/assessment_data_editor.dart';
import 'package:test_wizard/widgets/question_row.dart';

void main() {
  group('Question Row', () {
    test('correctly sets properties', () {
      QuestionRow row = const QuestionRow(
        questionId: 'question1',
        questionText: 'Test Question',
        answerText: 'Test Answer',
      );

      expect(row.questionId, 'question1');
      expect(row.questionText, 'Test Question');
      expect(row.answerText, 'Test Answer');
    });

    testWidgets('correctly renders components', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QuestionRow(
              questionId: 'question1',
              questionText: 'Test Question',
              answerText: 'Test Answer',
            ),
          ),
        ),
      );
      expect(find.byType(AssessmentDataEditor), findsNWidgets(2));
      expect(find.text('Test Question'), findsOneWidget);
      expect(find.text('Test Answer'), findsOneWidget);
    });
  });
}
