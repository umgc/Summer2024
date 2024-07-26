import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intelligrade/ui/create_page.dart';
import 'package:intelligrade/ui/setting_page.dart';
import 'package:intelligrade/ui/view_exam_page.dart';
import 'package:intelligrade/ui/grading_page.dart';
import 'package:intelligrade/ui/login_page.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
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
            '/login': (context) => const LoginPage(),
            '/grading': (context) => const Grading(),
            '/create': (context) => const CreatePage(),
            '/viewExams': (context) => const ViewExamPage(),
            '/settings': (context) => Setting(themeModeNotifier: _themeModeNotifier)
          },
        );
      },
    );
  }
}
