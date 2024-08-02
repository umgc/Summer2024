import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:test_wizard/models/assessment.dart';
import 'package:test_wizard/models/assessment_set.dart';
import 'package:test_wizard/providers/assessment_provider.dart';
import 'package:test_wizard/providers/user_provider.dart';
import 'package:test_wizard/widgets/cancel_button.dart';
import 'package:test_wizard/widgets/column_header.dart';
import 'package:test_wizard/widgets/edit_prompt.dart';
import 'package:test_wizard/widgets/qset.dart';
import 'package:test_wizard/widgets/scroll_container.dart';
import 'package:test_wizard/widgets/tw_app_bar.dart';

final logger = Logger();

class ModifyTestView extends StatelessWidget {
  final Assessment assessment;
  final String screenTitle;
  final String assessmentId;
  final int assessmentIndex;
  final int assessmentSetIndex;
  final String assessmentName;
  final String topic;
  final int courseId;

  const ModifyTestView({
    super.key,
    required this.screenTitle,
    required this.assessmentId,
    required this.assessmentIndex,
    required this.assessmentSetIndex,
    required this.assessment,
    required this.assessmentName,
    required this.topic,
    required this.courseId,
  });

  


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AssessmentProvider(),
      child: Scaffold(
        appBar: TWAppBar(context: context, screenTitle: screenTitle),
        backgroundColor: const Color(0xffe6f2ff),
        body: ScrollContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const ColumnHeaderRow(),
              QSet(assessmentId: assessmentId, assessmentIndex: assessmentIndex, assessmentSetIndex: assessmentSetIndex),
              ButtonContainer(
                screenTitle: screenTitle,
                assessmentName: assessmentName,
                topic: topic,
                courseId: courseId,
                assessmentIndex: assessmentIndex,
                assessmentSetIndex: assessmentSetIndex, 
                assessment:assessment 
              ),
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
        Flexible(
          fit: FlexFit.tight,
          child: Padding(
            padding: EdgeInsets.only(left: 120.0), // Adjust the padding as needed
            child: ColumnHeader(headerText: 'Answer'),
          ),
        ),
        //Expanded(child: ColumnHeader(headerText: 'Previous Question')),
      ],
    );
  }
}

class ButtonContainer extends StatelessWidget {
  final Assessment assessment;
  final int assessmentIndex;
  final int assessmentSetIndex;
  final String screenTitle;
  final String assessmentName;
  final String topic;
  final int courseId;

  const ButtonContainer({
    
    super.key, 
    required this.screenTitle,
    required this.assessmentName,
    required this.topic,
    required this.courseId,
    required this.assessmentIndex,
    required this.assessmentSetIndex,
    required this.assessment
  }
  );
  
  void _printQuestionsAndAnswers(BuildContext context) {
    final questions = assessment.questions;

    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(screenTitle, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              ...questions.map((qa) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Question: ${qa.questionText}'),
                    pw.Text('Answer: ${qa.answer}'),
                    pw.SizedBox(height: 20),
                  ],
                );
              }).toList(),
            ],
          );
        },
      ),
    );

    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }

  void _printQuestionsOnly(BuildContext context) {
    final questions = assessment.questions;

    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(screenTitle, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Student Name:', style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 20),
              pw.Text('Date:', style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 60), 
              ...questions.map((qa) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Question: ${qa.questionText}'),
                    pw.Text(qa.answerOptions.toString()), //William told me to do this.
                  pw.SizedBox(height: 80), 
                  ],
                );
              }).toList(),
            ],
          );
        },
      ),
    );

    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }

  Map<String, dynamic> _reformatAssessmentsJson(List<AssessmentSet> assessmentSets, String quizName) {
    final List<Map<String, dynamic>> questions = [];

    for (var assessmentSet in assessmentSets) {
      for (var assessment in assessmentSet.assessments) {
        if (assessmentSet.assessmentName == quizName) {
          for (var question in assessment.questions) {
            Map<String, dynamic> formattedQuestion;
            if (question.questionType == 'multipleChoice') {
              formattedQuestion = {
                'type': 'multichoice',
                'name': {
                  'text': 'TestWizard Created Multiple Choice Question',
                },
                'questiontext': {
                  'format': 'html',
                  'text': '<p>${question.questionText}</p>',
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
                'answer': question.answerOptions!
                    .map((option) {
                      return {
                        'fraction': option == question.answer ? 100 : 0,
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
            } else if (question.questionType == 'Short Answer') {

              formattedQuestion = {
                "type": "shortanswer",
                "name": {
                  "text": "TestWizard Created Short Answer Question"
                },
                "questiontext": {
                  "format": "html",
                  "text": '<p>${question.questionText}</p>'
                },
                "generalfeedback": {
                  "format": "html",
                  "text": "<p>The answer is: ${question.answer}</p>"
                },
                "defaultgrade": 1.0000000,
                "penalty": 0.3333333,
                "hidden": 0,
                "answer": [
                  {
                    "fraction": 100,
                    "format": "moodle_auto_format",
                    "text": question.answer,
                    "feedback": {
                      "format": "html",
                      "text": "<p>Correct!</p>"
                    }
                  },
                  {
                    "fraction": 0,
                    "format": "moodle_auto_format",
                    "text": "*",
                    "feedback": {
                      "format": "html",
                      "text": "<p>Incorrect</p>"
                    }
                  }
                ]
              };
            } else if (question.questionType == 'Essay') {
              formattedQuestion = {
                'type': 'essay',
                'name': {
                  'text': 'TestWizard Created Essay Question',
                },
                'questiontext': {
                  'format': 'html',
                  'text': '<p>${question.questionText}</p>',
                },
                'generalfeedback': {
                  'format': 'html',
                  'text': '',
                },
                'defaultgrade': 1,
                'penalty': 0.3333333,
                'hidden': 0,
                'idnumber': '',
              };
            } else {
              // If the question type is not supported, skip this question
              continue;
            }
            questions.add(formattedQuestion);
          }
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
    final assessmentProvider = Provider.of<AssessmentProvider>(context, listen: false);

    if (userProvider.moodleUrl == null) {
      logger.w('Moodle URL is not provided.');
      return;
    }

    if (userProvider.token == null) {
      logger.w('Token is not provided.');
      return;
    }

    final url = '${userProvider.moodleUrl}/webservice/rest/server.php';
    const createQuizFunction = 'local_testplugin_create_quiz';
    const importQuestionsFunction = 'local_testplugin_import_questions_json';
    const addQuestionToQuizFunction = 'local_testplugin_add_question_to_quiz';

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
          'questionjson': jsonEncode(_reformatAssessmentsJson(assessmentProvider.assessmentSets, quizName)),
        },
      );

      if (importResponse.statusCode != 200) {
        logger.e('Failed to import questions: ${importResponse.body}');
        return;
      }

      final importResponseBody = jsonDecode(importResponse.body);
      final questionIds = (importResponseBody as List<dynamic>).map((question) => question['questionid']).toList();

      if (questionIds.isEmpty) {
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
    return Consumer<AssessmentProvider>( 
      builder: (context, assessmentProvider, child){
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
                  assessmentProvider.updateAssessment(assessmentSetIndex, assessmentIndex, assessment);
                  assessmentProvider.saveAssessmentsToFile();
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
    );
  }
}
