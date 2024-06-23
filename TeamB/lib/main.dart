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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Launching Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
      routes: {
        '/dashboard': (context) => const Dashboard(),
        '/search': (context) => const Search(),
        '/testing': (context) => const TestingPage(),
        '/help': (context) => const Help(),
        '/notifications': (context) => const Notifications(),
        '/create': (context) => const CreatePage(),
        '/viewExams': (context) => const ViewExamPage(),
        '/settings': (context) => const Setting(),
      },
    );
  }
}
