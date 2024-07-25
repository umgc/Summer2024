import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intelligrade/ui/drawer.dart';
import 'package:intelligrade/ui/header.dart';
import 'package:intelligrade/controller/main_controller.dart';
import 'package:intelligrade/controller/model/beans.dart';
import 'package:google_fonts/google_fonts.dart';

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
    _fetchQuizzes();
  }

  Future<void> _fetchQuizzes() async {
    try {
      quizzes = ViewExamPage.controller.listAllAssessments();
      setState(() {});
    } catch (e) {
      print('Error fetching quizzes: $e');
      quizzes = [];
    }
  }

  void _showQuizDetails(Quiz quiz) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(quiz.name ?? 'Quiz Details'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          icon: Icon(Icons.edit,
                              color: Colors.black),
                          label: const Text('Edit'),
                          onPressed: () {
                            // Handle editing functionality here
                            Navigator.of(context).pop();
                            _editQuiz(quiz);
                          },
                        ),
                      ],
                    ),
                    for (int i = 0; i < quiz.questionList.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Question ${i + 1}: ${quiz.questionList[i].questionText ?? ''}',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            for (int j = 0;
                                j < quiz.questionList[i].answerList.length;
                                j++)
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  '${String.fromCharCode('a'.codeUnitAt(0) + j)}) ${quiz.questionList[i].answerList[j].answerText ?? ''}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: quiz.questionList[i].answerList[j]
                                                  .fraction ==
                                              '100'
                                          ? Colors.green
                                          : Colors.red),
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
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
      },
    );
  }

  void _editQuiz(Quiz quiz) async {
    // Create a list of controllers for each question and its answers
    List<List<TextEditingController>> controllers =
        quiz.questionList.map((question) {
      List<TextEditingController> questionControllers = [
        TextEditingController(text: question.questionText ?? '')
      ];

      // Add controllers for answers
      questionControllers.addAll(question.answerList
          .map((answer) => TextEditingController(text: answer.answerText ?? ''))
          .toList());

      return questionControllers;
    }).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Quiz'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...controllers.asMap().entries.map((entry) {
                  int questionIndex = entry.key;
                  List<TextEditingController> controllersForQuestion =
                      entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TextField for the question
                      TextField(
                        controller: controllersForQuestion[0],
                        decoration: InputDecoration(
                            labelText: 'Edit question ${questionIndex + 1}'),
                        onChanged: (text) {
                          quiz.questionList[questionIndex].questionText = text;
                        },
                      ),
                      ...controllersForQuestion
                          .sublist(1)
                          .asMap()
                          .entries
                          .map((answerEntry) {
                        int answerIndex = answerEntry.key;
                        TextEditingController controller = answerEntry.value;

                        return TextField(
                          controller: controller,
                          decoration: InputDecoration(
                              labelText:
                                  'Edit answer ${String.fromCharCode('a'.codeUnitAt(0) + answerIndex)}'),
                          onChanged: (text) {
                            quiz.questionList[questionIndex]
                                .answerList[answerIndex].answerText = text;
                          },
                        );
                      }).toList(),
                      SizedBox(height: 20),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Save'),
              onPressed: () async {
                try {
                  ViewExamPage.controller.updateFileLocally(quiz);
                  Navigator.of(context).pop();
                  _fetchQuizzes(); // Refresh quiz list
                } catch (e) {
                  print('Error updating quiz: $e');
                }
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteQuiz(String filename) async {
    final bool? confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this quiz?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        ViewExamPage.controller.deleteLocalFile(filename);
        _fetchQuizzes(); // Refresh quiz list
      } catch (e) {
        print('Error deleting quiz: $e');
      }
    }
  }

  void _downloadQuiz(Quiz quiz, bool includeAnswers) async {
    try {
      await ViewExamPage.controller
          .downloadAssessmentAsPdf(quiz.name ?? '', includeAnswers);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quiz downloaded successfully')),
      );
    } catch (e) {
      print('Error downloading quiz: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error downloading quiz')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(),
      drawer: const AppDrawer(),
      body: quizzes.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('No saved exams yet.'),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/create');
                    },
                    child: const Text('Create Exam'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: quizzes.length,
              itemBuilder: (BuildContext context, int index) {
                Quiz quiz = quizzes[index] ?? Quiz();
                return ListTile(
                  title: Text(quiz.name ?? 'Unnamed Quiz'),
                  subtitle: Text(quiz.description ?? 'No description'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteQuiz(quiz.name ??
                              ''); // Assumes quiz name is used as filename
                        },
                      ),
                      PopupMenuButton(
                        icon: const Icon(Icons.download, color: Colors.blue),
                        onSelected: (bool includeAnswers) {
                          _downloadQuiz(quiz, includeAnswers);
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<bool>>[
                          const PopupMenuItem<bool>(
                            value: true,
                            child: Text('Download with Answers'),
                          ),
                          const PopupMenuItem<bool>(
                            value: false,
                            child: Text('Download without Answers'),
                          ),
                        ],
                      )
                    ],
                  ),
                  onTap: () {
                    _showQuizDetails(quiz);
                  },
                );
              },
            ),
    );
  }
}
