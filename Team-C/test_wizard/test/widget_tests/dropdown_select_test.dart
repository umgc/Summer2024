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

    testWidgets('shows progress indicator before connecting', (tester) async {
      Widget app = MaterialApp(
        home: Scaffold(
          body: DropdownSelect(
            controller: controller,
            dropdownTitle: "Course",
            future: fakeDropdownFunction,
          ),
        ),
      );
      await tester.pumpWidget(app);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('on error renders error message', (tester) async {
      Widget app = MaterialApp(
        home: Scaffold(
          body: DropdownSelect(
            controller: controller,
            dropdownTitle: "Wrong Value",
            future: fakeDropdownFunction,
          ),
        ),
      );
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      expect(
          find.text('Error: Invalid argument: "Wrong Value"'), findsOneWidget);
    });

    testWidgets('on success renders list', (tester) async {
      Widget app = MaterialApp(
        home: Scaffold(
          body: DropdownSelect(
            controller: controller,
            dropdownTitle: "Course",
            future: fakeDropdownFunction,
          ),
        ),
      );
      await tester.pumpWidget(app);
      await tester.pump();
      expect(find.byType(DropdownMenuItem<String>), findsOneWidget);
      await tester.tap(find.byType(DropdownMenuItem<String>));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(DropdownMenuItem<String>, 'Course 1'),
          findsOneWidget);
      expect(find.widgetWithText(DropdownMenuItem<String>, 'Course 2'),
          findsOneWidget);
    });
  });
}
