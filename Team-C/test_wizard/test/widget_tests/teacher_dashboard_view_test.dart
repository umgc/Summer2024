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
      expect(find.widgetWithText(AppBar, "Teacher's Dashboard"),
          findsAtLeastNWidgets(1));
      expect(find.byType(ElevatedButton), findsAtLeastNWidgets(2));
      expect(find.widgetWithText(ElevatedButton, 'Create Assessment'),
          findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Login with Moodle'),
          findsOneWidget);
      expect(find.byType(SearchFilter), findsOneWidget);
      expect(find.byType(DataTable), findsOneWidget);
    });

    testWidgets('correctly renders login button as logged in', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TeacherDashboard(
            status: 'logged in',
          ),
        ),
      );
      expect(find.widgetWithText(ElevatedButton, 'Logout'), findsOneWidget);
    });

    testWidgets('Search Filter correctly searches', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: TeacherDashboard(),
        ),
      );
      await tester.pumpAndSettle();
      // THIS TEST WILL HAVE TO BE CHANGED WHEN WE LOAD REAL DATA
      expect(
        find.widgetWithText(ElevatedButton, 'Open'),
        findsExactly(2),
        reason:
            'This test assumes the Assessment Table is getting default data',
      );
      await tester.enterText(find.byType(TextField), 'Math');
      await tester.pumpAndSettle();
      expect(
        find.widgetWithText(ElevatedButton, 'Open'),
        findsExactly(1),
        reason:
            'This test assumes the Assessment Table is getting default data',
      );
      await tester.enterText(find.byType(TextField), 'Geography');
      await tester.pumpAndSettle();
      expect(
        find.widgetWithText(ElevatedButton, 'Open'),
        findsNothing,
        reason:
            'This test assumes the Assessment Table is getting default data, Math Quiz 1, Science Test',
      );
      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();
      expect(
        find.widgetWithText(ElevatedButton, 'Open'),
        findsExactly(2),
        reason:
            'This test assumes the Assessment Table is getting default data, Math Quiz 1, Science Test',
      );
    });
  });
}
