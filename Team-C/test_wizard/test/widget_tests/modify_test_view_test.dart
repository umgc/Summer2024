import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:test_wizard/models/assessment.dart';
import 'package:test_wizard/providers/assessment_provider.dart';
import 'package:test_wizard/views/modify_test_view.dart';


void main() {
  testWidgets('ModifyTestView has a title and DeletedQuestions widget', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AssessmentProvider(),
        child: MaterialApp(
          home: ModifyTestView(
            screenTitle: 'Test Title',
            assessmentId: '1',
            assessmentIndex: 1,
            assessmentSetIndex: 1,
            assessment: Assessment(1,1,false),
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
    //this widget is de-scoped
    //expect(find.byType(DeletedQuestions), findsOneWidget);
  });
}
