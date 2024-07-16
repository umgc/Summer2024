import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_wizard/widgets/create_base_assessment_form.dart';
import 'package:test_wizard/widgets/dropdown_select.dart';

void main() {
  group('create base assessment form', () {
    testWidgets('has assessment name text field', (tester) async {
      await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: CreateBaseAssessmentForm())));
      expect(find.widgetWithText(TextFormField, 'Assessment Name'),
          findsOneWidget);
    });
    testWidgets('has courseName dropdown', (tester) async {
      await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: CreateBaseAssessmentForm())));
      await tester.pump(Duration.zero);
      expect(find.widgetWithText(DropdownSelect, 'Course'), findsOneWidget);
    });
    testWidgets('has Number of tests text field', (tester) async {
      await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: CreateBaseAssessmentForm())));
      expect(find.widgetWithText(TextFormField, 'Number of Tests'),
          findsOneWidget);
    });
    testWidgets('has subject description text field', (tester) async {
      await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: CreateBaseAssessmentForm())));
      expect(find.widgetWithText(TextFormField, 'Subject Description'),
          findsOneWidget);
    });
    testWidgets('has assessment type dropdown', (tester) async {
      await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: CreateBaseAssessmentForm())));
      await tester.pump(Duration.zero);
      expect(find.widgetWithText(DropdownSelect, 'Assessment Type'),
          findsOneWidget);
    });
    testWidgets('has grading basis dropdown', (tester) async {
      await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: CreateBaseAssessmentForm())));
      await tester.pump();
      expect(find.widgetWithText(DropdownSelect, 'Graded On'), findsOneWidget);
    });

    testWidgets('has two buttons', (tester) async {
      await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: CreateBaseAssessmentForm())));
      expect(find.widgetWithText(ElevatedButton, 'Cancel'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Generate Assessment'),
          findsOneWidget);
    });
  });
}