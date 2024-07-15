import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_wizard/widgets/assessment_data_editor.dart';

void main() {
  group('AssessmentDataEditor component', () {
    testWidgets('correctly sets properties', (tester) async {
      AssessmentDataEditor editor = const AssessmentDataEditor(
        editorType: DataEditorType.question,
        text: 'testing text',
      );
      expect(editor.editorType, DataEditorType.question);
      expect(editor.text, 'testing text');
    });

    testWidgets('correctly renders components', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AssessmentDataEditor(
              editorType: DataEditorType.question,
              text: 'testing text',
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsOneWidget);
      expect(find.widgetWithText(Column, 'Question:'), findsOneWidget);
      expect(
        tester.widget(find.byType(TextField)),
        isA<TextField>().having(
          (tf) => tf.decoration,
          'decoration',
          isA<InputDecoration>().having(
            (id) => id.hintText,
            'hintText',
            'testing text',
          ),
        ),
      );
      expect(find.byType(IconRow), findsOneWidget);
    });
  });
}
