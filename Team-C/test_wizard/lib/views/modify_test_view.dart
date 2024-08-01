import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_wizard/widgets/cancel_button.dart';
import 'package:test_wizard/widgets/qset.dart';
import 'package:test_wizard/widgets/scroll_container.dart';
import 'package:test_wizard/widgets/tw_app_bar.dart';
import 'package:test_wizard/providers/question_answer_provider.dart';
import 'package:test_wizard/widgets/column_header.dart';
import 'package:test_wizard/widgets/deleted_questions.dart';
import 'package:test_wizard/widgets/edit_prompt.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:test_wizard/providers/user_provider.dart';

final logger = Logger();

class ModifyTestView extends StatelessWidget {
  final String screenTitle;
  final String assessmentId;

  const ModifyTestView({
    super.key,
    required this.screenTitle,
    required this.assessmentId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QuestionAnswerProvider(),
      child: Scaffold(
        appBar: TWAppBar(context: context, screenTitle: screenTitle),
        backgroundColor: const Color(0xffe6f2ff),
        body: ScrollContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const ColumnHeaderRow(),
              QSet(assessmentId: assessmentId),
              const ButtonContainer(),
              const EditPrompt(),
              const DeletedQuestions(),
            ],
          ),
        ),
      ),
    );
  }
}

class ColumnHeaderRow extends StatelessWidget {
  const ColumnHeaderRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: ColumnHeader(headerText: 'Question')),
        Expanded(
          child: Padding(
            padding:
                EdgeInsets.only(left: 24.0), // Adjust the padding as needed
            child: ColumnHeader(headerText: 'Answer'),
          ),
        ),
        Expanded(child: ColumnHeader(headerText: 'Previous Question')),
      ],
    );
  }
}

class ButtonContainer extends StatelessWidget {
  const ButtonContainer({super.key});

  void _printQuestionsAndAnswers(BuildContext context) {
    final questions =
        Provider.of<QuestionAnswerProvider>(context, listen: false).questions;

    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: questions.map((qa) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Question: ${qa.questionText}'),
                  pw.Text('Answer: ${qa.answerText}'),
                  pw.SizedBox(height: 20),
                ],
              );
            }).toList(),
          );
        },
      ),
    );

    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }

  void _printQuestionsOnly(BuildContext context) {
    final questions =
        Provider.of<QuestionAnswerProvider>(context, listen: false).questions;

    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: questions.map((qa) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Question: ${qa.questionText}'),
                  pw.SizedBox(height: 20),
                ],
              );
            }).toList(),
          );
        },
      ),
    );

    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }

  Future<void> addQuizToMoodle(BuildContext context, String quizName, String topic, int courseId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (userProvider.moodleUrl == null) {
      logger.w('Moodle URL is not provided.');
      return;
    }

    if (userProvider.token == null) {
      logger.w('Token is not provided.');
      return;
    }

    final url = '${userProvider.moodleUrl}/webservice/rest/server.php';
    final createQuizFunction = 'local_testplugin_create_quiz';
    final importQuestionsFunction = 'local_testplugin_import_questions_json';
    final addQuestionToQuizFunction = 'local_testplugin_add_question_to_quiz';

    try {
      // Create quiz
      final createQuizResponse = await http.post(
        Uri.parse(url),
        body: {
          'wsfunction': createQuizFunction,
          'wstoken': userProvider.token!,
          'courseid': courseId.toString(),
          'name': quizName,
          'intro': topic,
          'moodlewsrestformat': 'json',
        },
      );

      if (createQuizResponse.statusCode != 200) {
        logger.e('Failed to add quiz to Moodle: ${createQuizResponse.body}');
        return;
      }

      final createQuizResponseBody = jsonDecode(createQuizResponse.body);
      final quizId = createQuizResponseBody['quizid'];

      if (quizId == null) {
        logger.w('Quiz ID not found in response.');
        return;
      }

      logger.i('Quiz added to Moodle successfully! Quiz ID: $quizId');

      // Import questions
      final importResponse = await http.post(
        Uri.parse(url),
        body: {
          'wsfunction': importQuestionsFunction,
          'wstoken': userProvider.token!,
          'moodlewsrestformat': 'json',
          'questionjson': jsonEncode({
            "quiz": {
              "question": [
                {
                  "type": "category",
                  "category": {
                    "text": "\$course\$/top/Default for Site Home"
                  }
                },
                {
                  "type": "multichoice",
                  "name": {
                    "text": "TestWizard Created MultiChoice Question"
                  },
                  "questiontext": {
                    "format": "html",
                    "text": "<p>Test Wizard Created Questions</p>"
                  },
                  "generalfeedback": {
                    "format": "html",
                    "text": ""
                  },
                  "defaultgrade": 1,
                  "penalty": 0.3333333,
                  "hidden": 0,
                  "idnumber": "",
                  "single": true,
                  "shuffleanswers": true,
                  "answernumbering": "abc",
                  "showstandardinstruction": 0,
                  "correctfeedback": {
                    "format": "html",
                    "text": "<p>Your answer is correct.</p>"
                  },
                  "partiallycorrectfeedback": {
                    "format": "html",
                    "text": "<p>Your answer is partially correct.</p>"
                  },
                  "incorrectfeedback": {
                    "format": "html",
                    "text": "<p>Your answer is incorrect.</p>"
                  },
                  "shownumcorrect": {},
                  "answer": [
                    {
                      "fraction": 100,
                      "format": "html",
                      "text": "<p>a1</p>",
                      "feedback": {
                        "format": "html",
                        "text": ""
                      }
                    },
                    {
                      "fraction": 0,
                      "format": "html",
                      "text": "<p>a2</p>",
                      "feedback": {
                        "format": "html",
                        "text": ""
                      }
                    },
                    {
                      "fraction": 0,
                      "format": "html",
                      "text": "<p>a3</p>",
                      "feedback": {
                        "format": "html",
                        "text": ""
                      }
                    },
                    {
                      "fraction": 0,
                      "format": "html",
                      "text": "<p>a4</p>",
                      "feedback": {
                        "format": "html",
                        "text": ""
                      }
                    }
                  ]
                },
                {
                  "type": "multichoice",
                  "name": {
                    "text": "TestWizard Created MultiChoice Question 2"
                  },
                  "questiontext": {
                    "format": "html",
                    "text": "<p>Test Wizard Created Questions 2</p>"
                  },
                  "generalfeedback": {
                    "format": "html",
                    "text": ""
                  },
                  "defaultgrade": 1,
                  "penalty": 0.3333333,
                  "hidden": 0,
                  "idnumber": "",
                  "single": true,
                  "shuffleanswers": true,
                  "answernumbering": "abc",
                  "showstandardinstruction": 0,
                  "correctfeedback": {
                    "format": "html",
                    "text": "<p>Your answer is correct.</p>"
                  },
                  "partiallycorrectfeedback": {
                    "format": "html",
                    "text": "<p>Your answer is partially correct.</p>"
                  },
                  "incorrectfeedback": {
                    "format": "html",
                    "text": "<p>Your answer is incorrect.</p>"
                  },
                  "shownumcorrect": {},
                  "answer": [
                    {
                      "fraction": 100,
                      "format": "html",
                      "text": "<p>a1</p>",
                      "feedback": {
                        "format": "html",
                        "text": ""
                      }
                    },
                    {
                      "fraction": 0,
                      "format": "html",
                      "text": "<p>a2</p>",
                      "feedback": {
                        "format": "html",
                        "text": ""
                      }
                    },
                    {
                      "fraction": 0,
                      "format": "html",
                      "text": "<p>a3</p>",
                      "feedback": {
                        "format": "html",
                        "text": ""
                      }
                    },
                    {
                      "fraction": 0,
                      "format": "html",
                      "text": "<p>a4</p>",
                      "feedback": {
                        "format": "html",
                        "text": ""
                      }
                    }
                  ]
                }
              ]
            }
          }),
        },
      );

      if (importResponse.statusCode != 200) {
        logger.e('Failed to import questions: ${importResponse.body}');
        return;
      }

      final importResponseBody = jsonDecode(importResponse.body);
      final questionIds = importResponseBody.map((question) => question['questionid']).toList();

      if (questionIds == null || questionIds.isEmpty) {
        logger.w('Question IDs not found in response.');
        return;
      }

      logger.i('Questions imported successfully! Question IDs: $questionIds');

      // Add each question to the quiz
      for (final questionId in questionIds) {
        final addQuestionResponse = await http.post(
          Uri.parse(url),
          body: {
            'wsfunction': addQuestionToQuizFunction,
            'wstoken': userProvider.token!,
            'moodlewsrestformat': 'json',
            'questionid': questionId.toString(),
            'quizid': quizId.toString(),
          },
        );

        if (addQuestionResponse.statusCode != 200) {
          logger.e('Failed to add question $questionId to quiz: ${addQuestionResponse.body}');
          return;
        }
      }

      logger.i('All questions added to quiz successfully!');
    } catch (e) {
      logger.e('Error adding quiz to Moodle: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Wrap(
        alignment: WrapAlignment.end,
        runSpacing: 10,
        children: [
          ElevatedButton(
            onPressed: () => _printQuestionsAndAnswers(context),
            child: const Text('Print'),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () => _printQuestionsOnly(context),
            child: const Text('Print Questions Only'),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () async {
              final questionAnswerProvider = Provider.of<QuestionAnswerProvider>(context, listen: false);
              final assessmentName = "Assessment Name";
              final topic = "Topic";
              final courseId = 5; 

              await addQuizToMoodle(context, assessmentName, topic, courseId);
            },
            child: const Text('Save'),
          ),
          const SizedBox(width: 10),
          const CancelButton(),
        ],
      ),
    );
  }
}
