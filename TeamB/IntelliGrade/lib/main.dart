import 'package:flutter/material.dart';
import 'package:intelligrade/ui/create_page.dart';
import 'package:intelligrade/ui/feedbackpage.dart';
import 'package:intelligrade/ui/gradesuggestionpage.dart';
import 'package:intelligrade/ui/question_details_Page.dart';
import 'package:intelligrade/ui/notifications_page.dart';
import 'package:intelligrade/ui/search_page.dart';
import 'package:intelligrade/ui/setting_page.dart';
import 'package:intelligrade/ui/view_exam_page.dart';
import 'package:intelligrade/ui/help_page.dart';
import 'package:intelligrade/ui/testing_page.dart';
import 'package:intelligrade/ui/dashboard_page.dart';
import 'package:intelligrade/ui/login_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  MyApp({super.key});
  final ValueNotifier<ThemeMode> _themeModeNotifier = ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context)
  {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeModeNotifier,
      builder: (context, themeMode, child)
      {
        return MaterialApp(
          title: 'Launching Page',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark(),
          themeMode: themeMode,
          home: const LoginPage(),
          routes:
          {
            '/dashboard': (context) => const Dashboard(),
            '/gradesuggestion': (context) => const GradeSuggestionPage(),
            '/feedback': (context) => FeedbackPage(),
            '/login': (context) => LoginPage(),
            '/search': (context) => const Search(),
            '/testing': (context) => const Testing(),
            '/help': (context) => const Help(),
            '/notifications': (context) => const Notifications(),
            '/create': (context) => const CreatePage(),
            '/viewExams': (context) => const ViewExamPage(),
            '/questiondetails': (context) => const QuestionDetail(),
            '/settings': (context) => Setting(themeModeNotifier: _themeModeNotifier)
          },
        );
      },
    );
  }
}
