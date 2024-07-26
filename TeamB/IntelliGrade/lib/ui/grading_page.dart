import 'package:flutter/material.dart';
import 'package:intelligrade/ui/header.dart';

class Grading extends StatelessWidget {
  const Grading({super.key});

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
