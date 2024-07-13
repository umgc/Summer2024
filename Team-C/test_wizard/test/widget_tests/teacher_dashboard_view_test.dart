import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_wizard/views/teacher_dashboard_view.dart';

void main() {
  group('Teacher Dashboard', () {
    testWidgets('correctly renders components to screen', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TeacherDashboard(),
        ),
      );
      expect(find.byType(AppBar), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsAtLeastNWidgets(2));
      expect(find.widgetWithText(ElevatedButton, 'Create Assessment'),
          findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
      expect(find.byType(SearchFilter), findsOneWidget);
      expect(find.byType(DataTable), findsOneWidget);
    });
  });
}
