import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_wizard/widgets/dropdown_select.dart';

void main() {
  group('DropdownSelect component', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    Future<List<String>> fakeDropdownFunction(String optionName) async {
      if (optionName == 'Course') {
        return ['Select Course', 'Course 1', 'Course 2'];
      } else {
        throw ArgumentError.value(optionName);
      }
    }
    
    testWidgets('renders list correctly when enabled', (tester) async {
      Widget app = MaterialApp(
        home: Scaffold(
          body: DropdownSelect(
            isDisabled: false,
            controller: controller,
            dropdownTitle: "Course",
            options: ['Select Course', 'Course 1', 'Course 2'],
          ),
        ),
      );
      await tester.pumpWidget(app);
      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(DropdownMenuItem<String>, 'Course 1'), findsOneWidget);
      expect(find.widgetWithText(DropdownMenuItem<String>, 'Course 2'), findsOneWidget);
    });

    testWidgets('renders list correctly when disabled', (tester) async {
      Widget app = MaterialApp(
        home: Scaffold(
          body: DropdownSelect(
            isDisabled: true,
            controller: controller,
            dropdownTitle: "Course",
            options: ['Select Course', 'Course 1', 'Course 2'],
          ),
        ),
      );
      await tester.pumpWidget(app);
      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(DropdownMenuItem<String>, 'Course 1'), findsNothing);
      expect(find.widgetWithText(DropdownMenuItem<String>, 'Course 2'), findsNothing);
    });
  });
}
