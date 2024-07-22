import 'dart:typed_data';

import 'package:intelligrade/api/llm/llm_api.dart';
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
  final llm = LlmApi(dotenv.env['PERPLEXITY_API_KEY']!);

  Future<List<Quiz>> createAssessments(AssignmentForm userForm) async {
    var queryPrompt = getQueryPrompt(userForm);
    final String llmResp = await llm.postToLlm(queryPrompt); 
    final List<Map<String, dynamic>> parsedXmlList  = llm.parseQueryResponse(llmResp);
    var quizList = <Quiz>[];
    for (var xml in parsedXmlList) {
      quizList.add(Quiz.fromXmlString(xml.toString()));
    }
    return quizList;    
  }

  String getQueryPrompt(AssignmentForm userForm) {
    //waiting for Marsha's consts
    return '';
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
    html.document.cookie = '$cookieName=$cookieValue';
  }

  void downloadAssessmentAsPdf(String filename) async {
    if (filename.isEmpty) {
      throw Exception('Quiz name is required.');
    }

    String allCookies = html.document.cookie ?? '';
    List<String> cookieList = allCookies.split('; ');

    String cookieValue = cookieList.firstWhere((String cookie) {
      return cookie.startsWith('$filename=');
    });

    if (cookieValue == null) {
      throw Exception('No quiz found with the name: $filename');
    }

    // Convert XML string to PDF
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) =>
            pw.Text(cookieValue), // Simplified example
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
  }

  List<String> listAllAssessments() {
    // Retrieve all cookies as a single string
    String allCookies = html.document.cookie ?? '';

    // Split the cookie string into individual cookies
    List<String> cookieList = allCookies.split('; ');

    // Extract the cookie names
    return cookieList.map((String cookie) {
      return cookie.split('=').first;
    }).toList();
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

  void postAssessmentToMoodle(Quiz quiz) {
    // Handle posting logic
  }

  Quiz getAssessmentFromMoodle() {
    // Handle getting logic
    return Quiz();
  }

  String complieCodeAndGetOutput(String code) {
    // Handle compiling logic
    return '';
  }
}
