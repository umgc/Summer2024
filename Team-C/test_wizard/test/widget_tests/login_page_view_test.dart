import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:test_wizard/providers/assessment_provider.dart';
import 'package:test_wizard/views/login_page_view.dart';

void main() {
  testWidgets('Login Page correctly renders components', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (context) => AssessmentProvider(),
          child: const LoginPage(),
        ),
      ),
    );
    expect(
      find.widgetWithText(ElevatedButton, 'Login with Moodle'),
      findsOneWidget,
    );
    expect(find.text('TestWizard'), findsOne);
    expect(find.text('Login to TestWizard'), findsOne);
    expect(find.byType(Image), findsOne);
  });
}
