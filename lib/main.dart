import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mindinsync/HomeScreen.dart';
import 'package:mindinsync/RegisterScreen.dart';
import 'package:mindinsync/Search.dart';
import 'package:mindinsync/document_upload.dart';
import 'package:mindinsync/navigation.dart';
import 'registerPage.dart';
import 'LoginPage.dart';
import 'Disclaimer.dart';
import 'package:mindinsync/prompt.dart';
import 'login_page.dart';
import 'KnowledgeBase.dart';
import 'document_upload.dart';

//void main() => runApp(const MyApp());

TextEditingController emailController = TextEditingController();
void main() {
  emailController.text = 'test@example.com'; // You can load initial value here

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String appTitle = 'Flutter Drawer Demo';

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: const RegisterPage(),
      routes: {
        '/home': (context) => const Home(),
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/knowledge_base': (context) => const KnowledgeBase(),
        '/document_upload': (context) => const DocumentUpload(),
        '/Search': (context) => const Search(),
        '/Prompt': (context) => const PromptScreen(),
        '/Register': (context) => const RegisterScreen(),
      },
    );
  }
}
