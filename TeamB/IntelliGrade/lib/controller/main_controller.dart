import 'dart:typed_data';
import 'package:intelligrade/api/llm/llm_api.dart';
import 'package:intelligrade/api/llm/prompt_engine.dart';
import 'package:intelligrade/api/moodle/moodle_api_singleton.dart';
import 'package:intelligrade/controller/model/beans.dart';
import 'package:intelligrade/controller/model/xml_converter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'assessment_generator.dart';
import 'assessment_grader.dart';
import 'dart:html' as html;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart' as pdfWidgets;

class MainController {
  // Singleton instance
  static final MainController _instance = MainController._internal();
  // Singleton accessor
  factory MainController() {
    return _instance;
  }
  // Internal constructor
  MainController._internal();
  final llm = LlmApi(dotenv.env['PERPLEXITY_API_KEY']!);
  static bool isLoggedIn = false;

  Future<bool> createAssessments(AssignmentForm userForm) async {
    try {
      var queryPrompt = PromptEngine.generatePrompt(userForm);
      final String llmResp = await llm.postToLlm(queryPrompt);
      final List<String> parsedXmlList = llm.parseQueryResponse(llmResp);
      for (var xml in parsedXmlList) {
        var quiz = Quiz.fromXmlString(xml);
        quiz.name = userForm.title;
        quiz.description =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
        saveFileLocally(quiz);
      }
      return true;
    } catch (e) {
      // Handle any errors
      print('Error creating assessments: $e');
      return false;
    }
  }

  void gradeAssessment() {
    //TODO:
    //will use LLM
    // Handle grading logic
  }
  
  void saveFileLocally(Quiz quiz) {
    String quizName =
        quiz.name ?? DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
    String quizData = XmlConverter.convertQuizToXml(quiz).toString();
    html.window.localStorage[quizName] = quizData;
  }

  Future<bool> downloadAssessmentAsPdf(String filename, bool includeAnswers) async {
  if (filename.isEmpty) {
    throw Exception('Quiz name is required.');
  }

  try {
    String? quizData = html.window.localStorage[filename];
    if (quizData == null) {
      throw Exception('No quiz found with the name: $filename');
    }

    var quiz = Quiz.fromXmlString(quizData);

    // List of pdf widgets
    List<pw.Widget> widgets = [];

    // Add quiz title
    widgets.add(pw.Text(
      filename,
      style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
    ));
    widgets.add(pw.SizedBox(height: 10));

    // Add quiz description
    widgets.add(pw.Text(
      quiz.description ?? 'No description',
      style: pw.TextStyle(fontSize: 18, fontStyle: pw.FontStyle.italic),
    ));
    widgets.add(pw.SizedBox(height: 20));

    // Add each question and its answers
    for (var entry in quiz.questionList.asMap().entries) {
      final question = entry.value;
      final questionNumber = entry.key + 1;

      // Question text
      widgets.add(
        pw.Text(
          'Question $questionNumber: ${question.questionText}',
          style: pw.TextStyle(fontSize: 16),
        ),
      );
      widgets.add(pw.SizedBox(height: 5));

      // Answers
      List<pw.Widget> answerWidgets = [];
      for (var answerEntry in question.answerList.asMap().entries) {
        final index = answerEntry.key;
        final answer = answerEntry.value;
        final answerText = answer.answerText ?? '';
        final feedbackText = includeAnswers ? ' (${answer.feedbackText ?? ''})' : '';
        final prefix = question.type == QuestionType.multichoice.xmlName
            ? '${String.fromCharCode('a'.codeUnitAt(0) + index)})'
            : '-';

        answerWidgets.add(pw.Text(
          '$prefix $answerText$feedbackText',
          style: pw.TextStyle(fontSize: 14),
        ));
      }

      widgets.add(pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: answerWidgets,
      ));
      widgets.add(pw.SizedBox(height: 10));
    }

    // Create the PDF document
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.letter,
        build: (context) => widgets, // Pass the widgets list here
      ),
    );

    // Save the PDF as bytes
    final pdfBytes = await pdf.save();

    // Create a Blob from the PDF bytes
    final blob = html.Blob([Uint8List.fromList(pdfBytes)]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Create an anchor element and trigger the download
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', '$filename.pdf')
      ..click();

    // Cleanup
    html.Url.revokeObjectUrl(url);
    return true;
  } catch (e) {
    print('Error downloading assessment as PDF: $e');
    return false;
  }
}

  List<Quiz?> listAllAssessments() {
    var allKeys = html.window.localStorage.keys;
    List<Quiz?> allQuizzes = allKeys
        .map((String key) {
          try {
            String quizXml = html.window.localStorage[key] ?? '';
            var quiz = Quiz.fromXmlString(quizXml);
            quiz.name = key;
            return quiz;
          } catch (e) {
            print('Error parsing quiz: $e');
            return null; // Return null for invalid quizzes
          }
        })
        .where((quiz) => quiz != null)
        .toList();
    return allQuizzes;
  }

  void updateFileLocally(Quiz quiz) {
    if (quiz.name == null) {
      throw Exception('Quiz name is required.');
    }
    String quizName = quiz.name!;
    if (!html.window.localStorage.containsKey(quizName)) {
      throw Exception('No quiz found with the name: $quizName');
    }
    String quizData = XmlConverter.convertQuizToXml(quiz).toString();
    html.window.localStorage[quizName] = quizData;
  }

  void deleteLocalFile(String filename) {
    if (filename.isEmpty) {
      throw Exception('Filename is required.');
    }
    html.window.localStorage.remove(filename);
  }

  void postAssessmentToMoodle(Quiz quiz, String courseId) async {
    if (!isLoggedIn) {
      throw Exception('User is not logged in.');
    }
    String xml = XmlConverter.convertQuizToXml(quiz).toString();
    var moodleApi = MoodleApiSingleton();
    try {
      await moodleApi.importQuiz(courseId, xml);
      print('Questions successfully imported!');
    } catch (e) {
      print(e);
    }
  }

  Quiz getAssessmentFromMoodle() {
    // Handle getting logic
    return Quiz();
  }

  String complieCodeAndGetOutput(String code) {
    // Handle compiling logic
    return '';
  }

  Future<bool> loginToMoodle(String username, String password) async {
    var moodleApi = MoodleApiSingleton();
    try {
      await moodleApi.login(username, password);
      isLoggedIn = true;
      return true;
    } catch (e) {
      print(e);
      isLoggedIn = false;
      return false;
    }
  }

  Future<List<Course>> getCourses() async {
    var moodleApi = MoodleApiSingleton();
    try {
      List<Course> courses = await moodleApi.getCourses();
      return courses;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
