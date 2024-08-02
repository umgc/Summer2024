import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:test_wizard/providers/question_answer_provider.dart';
import 'package:test_wizard/views/modify_test_view.dart';
import 'package:test_wizard/widgets/deleted_questions.dart';

void main() {
  testWidgets('ModifyTestView has a title and DeletedQuestions widget', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => QuestionAnswerProvider(),
        child: const MaterialApp(
          home: ModifyTestView(
            screenTitle: 'Test Title',
            assessmentId: '1',
            assessmentName: 'Sample Assessment',
            topic: 'Sample Topic',
            courseId: 101,
          ),
        ),
      ),
    );

    // Verify if the title is present
    expect(find.text('Test Title'), findsOneWidget);

    // Verify if the DeletedQuestions widget is present
    expect(find.byType(DeletedQuestions), findsOneWidget);
  });
}
