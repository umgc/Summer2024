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
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';
import 'package:test_wizard/providers/user_provider.dart';

final logger = Logger();

class ModifyTestView extends StatelessWidget {
  final String screenTitle;
  final String assessmentId;
  final String assessmentName;
  final String topic;
  final int courseId;

  const ModifyTestView({
    super.key,
    required this.screenTitle,
    required this.assessmentId,
    required this.assessmentName,
    required this.topic,
    required this.courseId,
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
              ButtonContainer(
                assessmentName: assessmentName,
                topic: topic,
                courseId: courseId,
              ),
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
  final String assessmentName;
  final String topic;
  final int courseId;

  const ButtonContainer({
    super.key,
    required this.assessmentName,
    required this.topic,
    required this.courseId,
  });

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

  Future<String> _loadAssessmentsJson() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/assessments.txt');
      return await file.readAsString();
    } catch (e) {
      logger.e('Failed to read assessments file: $e');
      return '';
    }
  }

  Map<String, dynamic> _reformatAssessmentsJson(String assessmentsJson) {
    final parsedJson = jsonDecode(assessmentsJson);

    final List<Map<String, dynamic>> questions = [];

    for (var assessmentSet in parsedJson['assessmentSets']) {
      for (var assessment in assessmentSet['assessments']) {
        for (var question in assessment['questions']) {
          final formattedQuestion = {
            'type': 'multichoice',
            'name': {
              'text': 'TestWizard Created MultiChoice Question',
            },
            'questiontext': {
              'format': 'html',
              'text': '<p>${question['questionText']}</p>',
            },
            'generalfeedback': {
              'format': 'html',
              'text': '',
            },
            'defaultgrade': 1,
            'penalty': 0.3333333,
            'hidden': 0,
            'idnumber': '',
            'single': true,
            'shuffleanswers': true,
            'answernumbering': 'abc',
            'showstandardinstruction': 0,
            'correctfeedback': {
              'format': 'html',
              'text': '<p>Your answer is correct.</p>',
            },
            'partiallycorrectfeedback': {
              'format': 'html',
              'text': '<p>Your answer is partially correct.</p>',
            },
            'incorrectfeedback': {
              'format': 'html',
              'text': '<p>Your answer is incorrect.</p>',
            },
            'shownumcorrect': {},
            'answer': question['answerOptions']
                .asMap()
                .entries
                .map((entry) {
                  final index = entry.key;
                  final option = entry.value;
                  return {
                    'fraction': option == question['answer'] ? 100 : 0,
                    'format': 'html',
                    'text': '<p>$option</p>',
                    'feedback': {
                      'format': 'html',
                      'text': '',
                    },
                  };
                })
                .toList(),
          };
          questions.add(formattedQuestion);
        }
      }
    }

    return {
      'quiz': {
        'question': [
          {
            'type': 'category',
            'category': {
              'text': '\$course\$/top/Default for Site Home',
            },
          },
          ...questions,
        ],
      },
    };
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

      // Load questions from assessments.txt
      final assessmentsJson = await _loadAssessmentsJson();
      if (assessmentsJson.isEmpty) {
        logger.e('No assessments data found.');
        return;
      }

      // Reformat assessmentsJson
      final formattedAssessmentsJson = _reformatAssessmentsJson(assessmentsJson);

      // Import questions
      final importResponse = await http.post(
        Uri.parse(url),
        body: {
          'wsfunction': importQuestionsFunction,
          'wstoken': userProvider.token!,
          'moodlewsrestformat': 'json',
          'questionjson': jsonEncode(formattedAssessmentsJson),
        },
      );

      if (importResponse.statusCode != 200) {
        logger.e('Failed to import questions: ${importResponse.body}');
        return;
      }

      final importResponseBody = jsonDecode(importResponse.body);
      final questionIds = (importResponseBody as List<dynamic>).map((question) => question['questionid']).toList();

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
