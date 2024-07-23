import 'package:flutter/material.dart';
import 'package:intelligrade/ui/drawer.dart';
import 'package:intelligrade/ui/header.dart';
import 'package:intelligrade/controller/main_controller.dart';
import 'package:intelligrade/controller/model/beans.dart';

class ViewExamPage extends StatefulWidget {
  const ViewExamPage({super.key});
  static MainController controller = MainController();

  @override
  _ViewExamPageState createState() => _ViewExamPageState();
}

class _ViewExamPageState extends State<ViewExamPage> {
  List<Quiz?> quizzes = []; // Initialize as an empty list

  @override
  void initState() {
    super.initState();
    // Fetch quizzes
    try {
      quizzes = ViewExamPage.controller.listAllAssessments();
    } catch (e) {
      print('Error fetching quizzes: $e');
      quizzes = [];
    }
  }

  void _showQuizDetails(Quiz quiz) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(quiz.name ?? 'Quiz Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: quiz.questionList
                  .map((question) => Text(question.questionText ?? ''))
                  .toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(),
      drawer: const AppDrawer(),
      body: quizzes.isEmpty
          ? const Center(child: Text('No saved exams yet.'))
          : ListView.builder(
              itemCount: quizzes.length,
              itemBuilder: (BuildContext context, int index) {
                Quiz quiz = quizzes[index] ?? Quiz();
                return ListTile(
                  title: Text(quiz.name ?? 'Unnamed Quiz'),
                  subtitle: Text(quiz.description ?? 'No description'),
                  onTap: () {
                    _showQuizDetails(quiz);
                  },
                );
              },
            ),
    );
  }
}
