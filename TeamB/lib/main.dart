import 'package:flutter/material.dart';
import 'homepage.dart';
import 'api/moodle_connection_impl.dart';
import 'api/moodle_api_service.dart';

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
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => Homepage()));
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

    final moodleAPIService = MoodleAPIService(moodleConnection);

    // Example: Get Courses
    try {
      final courses = await moodleAPIService.getCourses();
      print('Courses: $courses');
    } catch (e) {
      print('Error fetching courses: $e');
    }

    // Example: Import Questions
    try {
      final questionData = {
        'questions': [
          {
            'category': 'testcategory',
            'questiontext': 'What is the capital of France?',
            'qtype': 'shortanswer',
            'answer': 'Paris'
          }
        ]
      };
      await moodleAPIService.importQuestions(questionData);
      print('Questions imported successfully');
    } catch (e) {
      print('Error importing questions: $e');
    }
  }

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
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
