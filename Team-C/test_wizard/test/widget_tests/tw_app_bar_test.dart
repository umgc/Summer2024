import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_wizard/widgets/tw_app_bar.dart';

void main() {
  group('TWAppBar component', () {
    testWidgets('returns an app bar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                appBar: TWAppBar(
                  context: context,
                  screenTitle: 'testing',
                ),
              );
            },
          ),
        ),
      );

      expect(find.byType(TWAppBar), findsOneWidget);
      expect(find.byType(AppBar),
          findsNWidgets(2)); // two because one is the bottom element
    });

    testWidgets('correctly sets screen title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                appBar: TWAppBar(
                  context: context,
                  screenTitle: 'testing',
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('testing'), findsOne);
    });
    testWidgets('correctly sets assessment and class name', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                appBar: TWAppBar(
                  context: context,
                  screenTitle: 'testing',
                  assessment: 'Final',
                  className: 'Biology',
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('Final, Biology'), findsOne);
    });
    testWidgets('throws an error when assessment is set without class name',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                appBar: TWAppBar(
                  context: context,
                  screenTitle: 'testing',
                  assessment: 'Final',
                ),
              );
            },
          ),
        ),
      );

      expect(tester.takeException(), isArgumentError);
    });
    testWidgets('throws an error when class name is set without assessment',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                appBar: TWAppBar(
                  context: context,
                  screenTitle: 'testing',
                  assessment: 'Final',
                ),
              );
            },
          ),
        ),
      );

      expect(tester.takeException(), isArgumentError);
    });
  });
}
