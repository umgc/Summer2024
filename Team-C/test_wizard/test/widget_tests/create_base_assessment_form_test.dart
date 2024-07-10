import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_wizard/widgets/create_base_assessment_form.dart';

void main() {
  group('create base assessment form', () {
    testWidgets('has assessment name text field', (tester) async {
      await tester
          .pumpWidget(const MaterialApp(home: CreateBaseAssessmentForm()));
      expect(find.widgetWithText(TextFormField, 'Assessment Name'),
          findsOneWidget);
    });
    testWidgets('has courseName dropdown', (tester) async {
      expect(find.widgetWithText(DropdownButtonFormField, 'Course'),
          findsOneWidget);
    });
    testWidgets('has Number of tests text field', (tester) async {
      expect(find.widgetWithText(TextFormField, 'Number of Tests'),
          findsOneWidget);
    });
    testWidgets('has subject description text field', (tester) async {
      expect(find.widgetWithText(TextFormField, 'Subject Description'),
          findsOneWidget);
    });
    testWidgets('has assessment type dropdown', (tester) async {
      expect(find.widgetWithText(DropdownButtonFormField, 'Assessment Type'),
          findsOneWidget);
    });
    testWidgets('has grading basis dropdown', (tester) async {
      expect(find.widgetWithText(DropdownButtonFormField, 'Graded On'),
          findsOneWidget);
    });
  });
}
