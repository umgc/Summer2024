import 'package:flutter/material.dart';
import 'homepage.dart';
import 'api/moodle_connection_factory.dart';

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

    final moodleConnectionFactory = MoodleConnectionFactory(
      baseUrl: 'http://100.25.213.47/',
      token: '4e825999a41297ea35dbddc465d92296',
    );

    final moodleAccessor = moodleConnectionFactory.createConnection();

    // Example: Get Courses
    try {
      final courses = await moodleAccessor.getCourses();
      print('Courses: $courses');
    } catch (e) {
      print('Error fetching courses: $e');
    }

    // Example: Create User
    try {
      final userData = {
        'users': [
          {
            'username': 'testusername1',
            'password': 'testpassword1',
            'firstname': 'testfirstname1',
            'lastname': 'testlastname1',
            'email': 'testemail1@moodle.com',
            'auth': 'manual',
            'idnumber': 'testidnumber1',
            'lang': 'en',
            'theme': 'standard',
            'timezone': '-12.5',
            'mailformat': '0',
            'description': 'Hello World!',
            'city': 'testcity1',
            'country': 'au',
            'preferences': [
              {'type': 'preference1', 'value': 'preferencevalue1'},
              {'type': 'preference2', 'value': 'preferencevalue2'}
            ]
          }
        ]
      };
      await moodleAccessor.createUser(userData);
      print('User created successfully');
    } catch (e) {
      print('Error creating user: $e');
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
