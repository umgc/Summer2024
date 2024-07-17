import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_wizard/views/login_page_view.dart';

void main() {
  testWidgets('Login Page correctly renders components', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
    expect(
      find.widgetWithText(ElevatedButton, 'Login with Moodle'),
      findsOneWidget,
    );
    expect(find.text('TestWizard'), findsOne);
    expect(find.text('Login to TestWizard'), findsOne);
    expect(find.byType(Image), findsOne);
  });
}
