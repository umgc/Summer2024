import 'package:flutter/material.dart';
import 'package:intelligrade/ui/header.dart';

import '../controller/main_controller.dart';

class GradingPage extends StatefulWidget {
  const GradingPage({super.key});

  static MainController controller = MainController();

  @override
  _GradingPageState createState() => _GradingPageState();
}

class _GradingPageState extends State<GradingPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppHeader(title: "Grade Exam"),
      body: Center(
        child: Text('Grading Page Content'),
      ),
    );
  }
}
