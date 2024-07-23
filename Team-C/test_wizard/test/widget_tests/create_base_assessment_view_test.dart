import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_wizard/views/create_base_assessment_view.dart';
import 'package:test_wizard/widgets/create_base_assessment_form.dart';
import 'package:test_wizard/widgets/tw_app_bar.dart';

void main() {
  group('Create Base Assessment View', () {
    testWidgets('renders TWAppBar', (tester) async {
      await tester
          .pumpWidget(const MaterialApp(home: CreateBaseAssessmentView()));
      expect(find.byType(TWAppBar), findsOneWidget);
    });
    testWidgets('renders Create Base Assessment Form', (tester) async {
      await tester
          .pumpWidget(const MaterialApp(home: CreateBaseAssessmentView()));
      expect(find.byType(CreateBaseAssessmentForm), findsOneWidget);
    });
  });
}