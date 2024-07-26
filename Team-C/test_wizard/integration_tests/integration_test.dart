import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:test_wizard/main.dart';
import 'package:test_wizard/models/assessment.dart';
import 'package:test_wizard/models/assessment_set.dart';
import 'package:test_wizard/models/course.dart';
import 'package:test_wizard/models/saved_assessments.dart';
import 'package:test_wizard/providers/assessment_provider.dart';
import 'package:test_wizard/providers/user_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end to end test', () {
    testWidgets(
      'user can go through the process of creating an assessment as a guest',
      (tester) async {
        // this sets up the applicationDocumentDirectory mock channel
        const channel = MethodChannel(
          'plugins.flutter.io/path_provider',
        );
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          channel,
          (methodCall) async {
            if (methodCall.method == 'getApplicationDocumentsDirectory') {
              return "./";
            }
            return '';
          },
        );

        // set up an assessment set for the app to find
        AssessmentSet newSet = AssessmentSet(
            [Assessment(0, 0)], 'Math Test', Course(0, 'Geometry 101'));
        SavedAssessments saved = SavedAssessments();
        saved.assessmentSets = [newSet];
        saved.saveAssessmentsToFile();

        // set up the app
        await tester.pumpWidget(MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => AssessmentProvider()),
            ChangeNotifierProvider(create: (context) => UserProvider()),
          ],
          child: const MyApp(),
        ));
        await tester.pumpAndSettle();

        // try to login with invalid credentials
        await tester.tap(find.text('Login with Moodle'));
        await tester.pumpAndSettle();
        expect(find.text('Invalid Username, Password, and/or URL'), findsOne);

        // tap on the login as guest button
        await tester.tap(find.text('Login as Guest'));
        await tester.pumpAndSettle();
        expect(find.text('Math Test'), findsAtLeast(1));
        expect(find.text('Geometry 101'), findsAtLeast(1));

        // move to create assessment form
        await tester.tap(find.text('Create Assessment'));
        await tester.pumpAndSettle();
        expect(find.text('Disabled without Moodle'), findsOneWidget);

        // fill out form fields
        await tester.enterText(
            find.widgetWithText(TextFormField, 'Assessment Name'),
            'Biology Test');
        await tester.enterText(
            find.widgetWithText(TextFormField, 'Number of Tests'), '12');
        //test error
        await tester.tap(find.widgetWithText(ElevatedButton, 'Add Questions'));
        await tester.pumpAndSettle();
        expect(find.text('This field cannot be blank.'), findsOneWidget);
        // finish filling out form and move on
        await tester.enterText(
            find.widgetWithText(TextFormField, 'Subject Description'),
            'Cellular Biology');
        // successfully move to the Add Questions page
        await tester.tap(find.widgetWithText(ElevatedButton, 'Add Questions'));
        await tester.pumpAndSettle();
        // expect one question that is blank
        expect(find.text('Short Answer'), findsOne);
        expect(find.widgetWithText(TextFormField, 'What is 2 + 2?'), findsOne);
        // test the dropdown
        await tester.tap(find.text('Short Answer'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Multiple Choice'));
        await tester.pumpAndSettle();
        expect(find.text('Multiple Choice'), findsOne);
        await tester.tap(find.text('Multiple Choice'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Essay'));
        await tester.pumpAndSettle();
        expect(find.text('Essay'), findsOne);

        // test the form field error handling
        await tester.tap(find.text('Generate Assessment'));
        await tester.pumpAndSettle();
        expect(find.text('This field cannot be blank.'), findsOneWidget);

        // test the add question button
        var found = find.widgetWithText(TextFormField, 'What is 2 + 2?');
        await tester.tap(found);
        await tester.enterText(found, 'What is the nucleus1?');
        await tester.pumpAndSettle();
        expect(find.byType(TextFormField), findsOne);
        expect(find.text('What is the nucleus1?'), findsOne);
        await tester.tap(find.text('Add Question'));
        await tester.pumpAndSettle();
        expect(find.byType(TextFormField), findsExactly(2));

        // test remove button
        await tester.tap(find.byType(IconButton).first);
        await tester.pumpAndSettle();
        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.widgetWithText(TextFormField, 'What is 2 + 2?'), findsOne);
        // fill out the form and try to generate an assessment, expect an error because of no API keys
        var finder = find.widgetWithText(TextFormField, 'What is 2 + 2?');
        await tester.tap(finder);
        await tester.enterText(finder, 'What is the nucleus2?');
        await tester.pumpAndSettle();
        expect(finder, findsOne);
        expect(find.text('What is the nucleus2?'), findsOne);
        await tester.tap(find.text('Generate Assessment'));
        await tester.pumpAndSettle();
        expect(
            find.widgetWithText(TextField,
                'Something went wrong with the request to Perplexity'),
            findsOne);
        // go back to test the cancel buttons
        await tester.tap(find.byTooltip('Back'));
        await tester.pumpAndSettle();
        expect(find.widgetWithText(ElevatedButton, 'Add Questions'), findsOne);
        expect(find.widgetWithText(ElevatedButton, 'Cancel'), findsOne);

        await tester.tap(find.widgetWithText(ElevatedButton, 'Cancel'));
        await tester.pumpAndSettle();
        expect(find.text("Teacher's Dashboard"), findsOne);

        await tester.tap(find.text('Login with Moodle'));
        await tester.pumpAndSettle();
        expect(find.text('Login with Moodle'), findsOne);
        expect(find.text('Login as Guest'), findsOne);
      },
    );
  });
}
