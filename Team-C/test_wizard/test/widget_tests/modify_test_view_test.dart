import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:test_wizard/providers/question_answer_provider.dart';
import 'package:test_wizard/views/modify_test_view.dart';
import 'package:test_wizard/widgets/deleted_questions.dart'; // Add this import

void main() {
  testWidgets('ModifyTestView has a title and message', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => QuestionAnswerProvider(),
        child: const MaterialApp(
          home: ModifyTestView(
            screenTitle: 'Test Title',
            assessmentId: '1',
            assessmentIndex: 1,
            assessmentSetIndex: 1,
          ),
        ),
      ),
    );

    expect(find.text('Test Title'), findsOneWidget);
    expect(find.byType(DeletedQuestions), findsOneWidget); // Ensure DeletedQuestions is used
  });
}
