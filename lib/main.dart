import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mindinsync/HomeScreen.dart';
import 'package:mindinsync/document_upload.dart';
import 'package:mindinsync/navigation.dart';
import 'login_page.dart';
import 'KnowledgeBase.dart';
import 'document_upload.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  final String appTitle = 'Flutter Drawer Demo';

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: const LoginPage(),
      routes: {
        '/home': (context) => const Home(),
        '/login': (context) => const LoginPage(),
        '/knowledge_base': (context) => const KnowledgeBase(),
        '/document_upload': (context) => const DocumentUpload(),
      },
    );
  }
}
