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
    final List<String> parsedXmlList =
        llm.parseQueryResponse(llmResp);
    for (var xml in parsedXmlList) {
      var quiz = Quiz.fromXmlString(xml);
      quiz.name = userForm.title;
      quiz.description = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
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

  Quiz viewLocalAssessment(String filename) {
    if (filename.isEmpty) {
      throw Exception('Filename is required.');
    }
    String allCookies = html.document.cookie ?? '';
    List<String> cookieList = allCookies.split('; ');

    String cookieValue = cookieList.firstWhere((String cookie) {
      return cookie.startsWith('$filename=');
    });

    if (cookieValue.isEmpty) {
      throw Exception('No quiz found with the name: $filename');
    }

    return Quiz.fromXmlString(cookieValue);
  }

  void settings() {
    //what is this supposed to do?
    // Handle settings logic
  }

  void saveFileLocally(Quiz quiz) {
    String cookieName =
        quiz.name ?? DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
    String cookieValue = XmlConverter.convertQuizToXml(quiz).toString();
    final hundredYearsFromNow = DateTime.now().add(Duration(days: 365 * 100)).toUtc().toIso8601String();
    html.document.cookie = '$cookieName=$cookieValue; expires=$hundredYearsFromNow; path=/';
  }

  Future<bool> downloadAssessmentAsPdf(String filename, bool includeAnswers) async {
  if (filename.isEmpty) {
    throw Exception('Quiz name is required.');
  }
  try {
    String allCookies = html.document.cookie ?? '';
    List<String> cookieList = allCookies.split('; ');

    String cookieValue = cookieList.firstWhere((String cookie) {
      return cookie.startsWith('$filename=');
    }, orElse: () => '');

    if (cookieValue.isEmpty) {
      throw Exception('No quiz found with the name: $filename');
    }

    var quiz = Quiz.fromXmlString(cookieValue);

    // Create PDF document
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(filename, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text(quiz.description ?? 'No description', style: pw.TextStyle(fontSize: 18, fontStyle: pw.FontStyle.italic)),
              pw.SizedBox(height: 20),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: quiz.questionList.asMap().entries.map((entry) {
                  final question = entry.value;
                  final questionNumber = entry.key + 1;

                  // Determine the answer prefix based on question type
                  List<pw.Widget> answerWidgets = [];
                  if (question.type == QuestionType.multichoice.xmlName) {
                    // Multiple choice question - use letters a), b), c), etc.
                    final options = question.answerList.asMap().entries.map((answerEntry) {
                      final optionLetter = String.fromCharCode('a'.codeUnitAt(0) + answerEntry.key);
                      final answerText = answerEntry.value.answerText;
                      final feedbackText = includeAnswers ? ' (${answerEntry.value.feedbackText ?? ''})' : '';
                      return pw.Text(
                        '$optionLetter) $answerText${includeAnswers ? ' $feedbackText' : ''}',
                        style: pw.TextStyle(fontSize: 14),
                      );
                    }).toList();
                    answerWidgets.addAll(options);
                  } else {
                    // Other question types - use hyphens
                    answerWidgets.addAll(question.answerList.map((answer) {
                      final answerText = answer.answerText;
                      final feedbackText = includeAnswers ? ' (${answer.feedbackText ?? ''})' : '';
                      return pw.Text(
                        '- $answerText${includeAnswers ? ' $feedbackText' : ''}',
                        style: pw.TextStyle(fontSize: 14),
                      );
                    }).toList());
                  }

                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Question $questionNumber: ${question.questionText}', style: pw.TextStyle(fontSize: 16)),
                      pw.SizedBox(height: 5),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: answerWidgets,
                      ),
                      pw.SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              ),
            ],
          );
        },
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
    // Retrieve all cookies as a single string
    String allCookies = html.document.cookie ?? '';

    print('All cookies: $allCookies');

    // Split the string into a list of cookies
    List<String> cookieList = allCookies.split('; ');

    // Map the cookies to Quiz objects, with error handling
    List<Quiz?> allQuizzes = cookieList.map((String cookie) {
      try {
        // Split the cookie into a key-value pair
        List<String> cookieParts = cookie.split('=');

        // Ensure the cookie has both a key and a value
        if (cookieParts.length < 2) {
          throw FormatException('Invalid cookie format');
        }

        // Return the key as the quiz name and the value as the quiz XML string
        String quizName = cookieParts[0];
        String quizXml = cookieParts.sublist(1).join('=').trim();
        print(quizXml);

        // Convert the XML string to a Quiz object
        var quiz = Quiz.fromXmlString(quizXml);
        quiz.name = quizName;
        return quiz;
      } catch (e) {
        print('Error parsing cookie: $e');
        return null; // Return null for invalid cookies
      }
    }).where((quiz) => quiz != null).toList();

    return allQuizzes;
  }

  void updateFileLocally(Quiz quiz) {
    if (quiz.name == null) {
      throw Exception('Quiz name is required.');
    }
    String cookieName = quiz.name ?? '';
    String allCookies = html.document.cookie ?? '';

    List<String> cookieList = allCookies.split('; ');

    bool cookieExists = cookieList.any((String cookie) {
      return cookie.startsWith('$cookieName=');
    });

    if (!cookieExists) {
      // Return an error if no cookie has the file name
      throw Exception('No cookie found with the name: $cookieName');
    }

    // Convert quiz to XML string
    String cookieValue = XmlConverter.convertQuizToXml(quiz).toString();

    // Set the updated cookie
    html.document.cookie = '$cookieName=$cookieValue';
  }

  void deleteLocalFile(String filename) {
    if (filename.isEmpty) {
      throw Exception('Filename is required.');
    }

    // Set the cookie with the same name but with an expired date to delete it
    final cookieName = filename;

    // To delete the cookie, set its expiration date to a past date
    final pastDate =
        DateTime.now().subtract(Duration(days: 365)).toUtc().toIso8601String();

    // Set the cookie with an expired date and empty value
    html.document.cookie = '$cookieName=; expires=$pastDate; path=/';
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
