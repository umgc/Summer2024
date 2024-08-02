import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_wizard/widgets/dropdown_select.dart';

void main() {
  group('DropdownSelect component', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    testWidgets('DropdownSelect displays and interacts correctly', (tester) async {
      final List<Map<String, dynamic>> options = [
        {'id': 1, 'fullname': 'Select Course'},
        {'id': 2, 'fullname': 'Course 1'},
        {'id': 3, 'fullname': 'Course 2'}
      ];

      Widget app = MaterialApp(
        home: Scaffold(
          body: DropdownSelect(
            isDisabled: false,
            controller: controller,
            dropdownTitle: "Course",
            options: options,
          ),
        ),
      );

      await tester.pumpWidget(app);

      // Check if DropdownSelect is displayed with the correct title
      expect(find.text('Course'), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<Map<String, dynamic>>), findsOneWidget);

      // Tap on the dropdown to open the list of options
      await tester.tap(find.byType(DropdownButtonFormField<Map<String, dynamic>>));
      await tester.pumpAndSettle();

      // Check if the dropdown options are displayed
      expect(find.widgetWithText(DropdownMenuItem<Map<String, dynamic>>, 'Course 1'), findsOneWidget);
      expect(find.widgetWithText(DropdownMenuItem<Map<String, dynamic>>, 'Course 2'), findsOneWidget);

      // Select an option and check if it updates the controller
      await tester.tap(find.text('Course 1').last);
      await tester.pumpAndSettle();

      expect(controller.text, 'Course 1');
    });

    testWidgets('DropdownSelect shows disabled hint when isDisabled is true', (tester) async {
      final List<Map<String, dynamic>> options = [
        {'id': 1, 'fullname': 'Select Course'},
        {'id': 2, 'fullname': 'Course 1'},
        {'id': 3, 'fullname': 'Course 2'}
      ];

      Widget app = MaterialApp(
        home: Scaffold(
          body: DropdownSelect(
            isDisabled: true,
            controller: controller,
            dropdownTitle: "Course",
            options: options,
          ),
        ),
      );

      await tester.pumpWidget(app);

      // Check if DropdownSelect shows disabled hint
      expect(find.text('Disabled without Moodle'), findsOneWidget);
    });

    testWidgets('DropdownSelect shows validation error when no option is selected', (tester) async {
      final List<Map<String, dynamic>> options = [
        {'id': 1, 'fullname': 'Select Course'},
        {'id': 2, 'fullname': 'Course 1'},
        {'id': 3, 'fullname': 'Course 2'}
      ];

      Widget app = MaterialApp(
        home: Scaffold(
          body: Form(
            child: DropdownSelect(
              isDisabled: false,
              controller: controller,
              dropdownTitle: "Course",
              options: options,
            ),
          ),
        ),
      );

      await tester.pumpWidget(app);

      // Try to submit the form without selecting an option
      final formState = tester.state(find.byType(Form)) as FormState;
      formState.validate();

      // Check if validation error is shown
      expect(find.text('Please select a valid option'), findsOneWidget);
    });
  });
}
