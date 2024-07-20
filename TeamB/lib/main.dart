import 'package:flutter/material.dart';
import 'homepage.dart';
import 'api/moodle_connection_impl.dart';
import 'api/moodle_api_service.dart';
import 'create_page.dart';
import 'question_details_page.dart';
import 'notifications_page.dart';
import 'search_page.dart';
import 'setting_page.dart';
import 'view_exam_page.dart';
import 'help_page.dart';
import 'testing_page.dart';
import 'dashboard_page.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo H'),
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
  int _counter = 0;

  void _openHomePage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Homepage()));
  }

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });

    final moodleConnection = MoodleConnectionImpl();
    moodleConnection.setMoodleUrl(
      'http://100.25.213.47/webservice/rest/server.php',
      '4e825999a41297ea35dbddc465d92296',
      'http://100.25.213.47',
    );

    final moodleAPIService = Mo
