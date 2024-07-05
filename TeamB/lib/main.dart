import 'package:flutter/material.dart';
import 'package:teamb_intelligrade/create_page.dart';
import 'package:teamb_intelligrade/notifications_page.dart';
import 'package:teamb_intelligrade/search_page.dart';
import 'package:teamb_intelligrade/setting_page.dart';
import 'package:teamb_intelligrade/view_exam_page.dart';
import 'help_page.dart';
import 'testing_page.dart';
import 'dashboard_page.dart';
import 'login_page.dart';


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
            '/search': (context) => const Search(),
            '/testing': (context) => const Testing(),
            '/help': (context) => const Help(),
            '/notifications': (context) => const Notifications(),
            '/create': (context) => const CreatePage(),
            '/viewExams': (context) => const ViewExamPage(),
            '/settings': (context) => Setting(themeModeNotifier: _themeModeNotifier)
          },
        );
      },
    );
  }
}
