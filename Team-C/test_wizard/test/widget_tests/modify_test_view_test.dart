import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_wizard/views/modify_test_view.dart';
import 'package:test_wizard/widgets/question_set.dart';
import 'package:test_wizard/widgets/tw_app_bar.dart';

void main() {
  group('Modify Test View', () {
    testWidgets('correctly renders components', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ModifyTestView(
            screenTitle: 'Testing Screen',
            assessmentId: 'TestingAssessment',
          ),
        ),
      );

      expect(find.byType(TWAppBar), findsOneWidget);
      expect(find.widgetWithText(AppBar, 'TestWizard'), findsOneWidget);
      expect(find.widgetWithText(AppBar, 'Testing Screen'),
          findsAtLeastNWidgets(1));
      expect(find.byType(ColumnHeaderRow), findsOneWidget);
      expect(find.byType(QuestionSet), findsOneWidget);
      expect(find.byType(ButtonContainer), findsOneWidget);
      expect(find.byType(DeletedQuestions), findsOneWidget);
    });
  });
}
