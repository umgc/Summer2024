import 'package:flutter/material.dart';
import 'package:teamb_intelligrade/create_page.dart';
import 'package:teamb_intelligrade/notifications_page.dart';
import 'package:teamb_intelligrade/search_page.dart';
import 'package:teamb_intelligrade/setting_page.dart';
import 'package:teamb_intelligrade/view_exam_page.dart';
import 'help_page.dart';
import 'testing_page.dart';
import 'dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/dashboard');
              },
              child: const Text('Go to the dashboard Page'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/search');
              },
              child: const Text('Go to the Search Page'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/testing');
              },
              child: const Text('Go to the Test Page'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/help');
              },
              child: const Text('Go to the Help Page'),
            ),
          ],
        ),
      ),
    );
  }
}