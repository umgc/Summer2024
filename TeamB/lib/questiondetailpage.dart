import 'package:flutter/material.dart';

void main() {
  runApp(IntelliGradeApp());
}

class IntelliGradeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IntelliGrade',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuestionDetailPage(),
    );
  }
}

class QuestionDetailPage extends StatelessWidget {
  final String questionText = "What is the capital of France?";
  final List<String> choices = ["Berlin", "Madrid", "Paris", "Rome"];
  final String correctAnswer = "Paris";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Question Text:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              questionText,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Choices:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            ...choices.map((choice) => Text(
                  choice,
                  style: TextStyle(fontSize: 16),
                )),
            SizedBox(height: 16),
            Text(
              'Correct Answer:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              correctAnswer,
              style: TextStyle(fontSize: 16, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
