import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_wizard/widgets/dropdown_select.dart';

void main() {
  group('DropdownSelect component', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    // Future<List<Map<String, dynamic>>> fakeDropdownFunction(String optionName) async {
    //   if (optionName == 'Course') {
    //     return [
    //       {'id': 0, 'fullname': 'Select Course'},
    //       {'id': 1, 'fullname': 'Course 1'},
    //       {'id': 2, 'fullname': 'Course 2'},
    //     ];
    //   } else {
    //     throw ArgumentError.value(optionName);
    //   }
    // }
    
    testWidgets('renders list correctly when enabled', (tester) async {
      Widget app = MaterialApp(
        home: Scaffold(
          body: DropdownSelect(
            isDisabled: false,
            controller: controller,
            dropdownTitle: "Course",
            options: const [
              {'id': 0, 'fullname': 'Select Course'},
              {'id': 1, 'fullname': 'Course 1'},
              {'id': 2, 'fullname': 'Course 2'},
            ],
          ),
        ),
      );
      await tester.pumpWidget(app);
      expect(find.byType(DropdownButtonFormField<Map<String, dynamic>>), findsOneWidget);
      await tester.tap(find.byType(DropdownButtonFormField<Map<String, dynamic>>));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(DropdownMenuItem<Map<String, dynamic>>, 'Course 1'), findsOneWidget);
      expect(find.widgetWithText(DropdownMenuItem<Map<String, dynamic>>, 'Course 2'), findsOneWidget);
    });

    testWidgets('renders list correctly when disabled', (tester) async {
      Widget app = MaterialApp(
        home: Scaffold(
          body: DropdownSelect(
            isDisabled: true,
            controller: controller,
            dropdownTitle: "Course",
            options: const [
              {'id': 0, 'fullname': 'Select Course'},
              {'id': 1, 'fullname': 'Course 1'},
              {'id': 2, 'fullname': 'Course 2'},
            ],
          ),
        ),
      );
      await tester.pumpWidget(app);
      expect(find.byType(DropdownButtonFormField<Map<String, dynamic>>), findsOneWidget);
      await tester.tap(find.byType(DropdownButtonFormField<Map<String, dynamic>>));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(DropdownMenuItem<Map<String, dynamic>>, 'Course 1'), findsNothing);
      expect(find.widgetWithText(DropdownMenuItem<Map<String, dynamic>>, 'Course 2'), findsNothing);
    });
  });
}
