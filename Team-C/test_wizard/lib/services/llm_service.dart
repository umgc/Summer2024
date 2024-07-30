import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:test_wizard/models/assessment.dart';
import 'package:test_wizard/providers/assessment_provider.dart';

class LLMService {
  final String _url = 'https://api.perplexity.ai/chat/completions';
  final String _apiKey = const String.fromEnvironment('API_KEY');
  List<Map<String, String>> messages = [
    {
      'role': 'system',
      'content': // the system prompt is something that gives the AI context into the type of job it will perform.
          'Only return the format specified in the prompt.',
    },
  ];

  LLMService();

  String buildPrompt(
    String topic,
    AssessmentProvider assessmentProvider,
    bool isMathQuiz,
    int exampleAssessmentSetIndex,
    int exampleAssessmentIndex
  ) {
    var typeMap = assessmentProvider.getQuestionTypeCount();
    Assessment exampleAssessment = assessmentProvider.getAssessmentFromAssessmentSet(exampleAssessmentSetIndex, exampleAssessmentIndex);
    int multipleChoiceCount = typeMap['Multiple Choice']!;
    int shortAnswerCount = typeMap['Short Answer']!;
    int essayCount = typeMap['Essay']!;
    int totalCount = multipleChoiceCount + shortAnswerCount + essayCount;

    if(exampleAssessment.assessmentId == -1){
      exampleAssessment = assessmentProvider.a;
    }

    return '''${isMathQuiz ? 'The focus of this assessment is math. ' : ''}Please generate as many complete assessments as you can with $totalCount questions each based on the following assessment. This assessment is about the subject $topic. Each assessment should be very similar to the original assessment and include $multipleChoiceCount multiple choice questions, 0 math questions, $shortAnswerCount short answer questions and $essayCount essay questions. Essay questions should instead include a grading rubric. Provide each assessment formatted as its own json. 
Use in the following format for short answer and math questions:
QUESTION NUMBER:
TYPE:
QUESTION:
ANSWER:

Use the following format for multiple choice questions:
QUESTION NUMBER:
TYPE:
QUESTION:
OPTIONS:
ANSWER:

Use the following format for essay questions:
QUESTION NUMBER:
TYPE:
QUESTION:
RUBRIC:

Check your answers to ensure they are correct. Do not provide the work checking in your response but edit the JSON with the correct answer if you find errors. Do not include any questions that are copied directly from the internet. None of the assessments should contain exact copies of the assessments provided in this prompt. Only return assessments that include all $totalCount questions.
    ${exampleAssessment.getAssessmentAsJson()}''';
  }

  Future<http.Response> sendRequest(http.Client httpClient, String prompt) {
    messages.add({'role': 'user', 'content': prompt});
    return httpClient.post(
      Uri.parse(_url),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
      },
      body: jsonEncode(
          {'model': 'llama-3-sonar-small-32k-online', 'messages': messages}),
    );
  }

  (Map<String, dynamic>?, String)? extractAssessment(String input) {
    // we need to look for the first time we see ```json
    int startIndex = input.indexOf('```json');
    if (startIndex < 0) return null;
    // then find the end of the json
    int endIndex = input.indexOf('```', startIndex + 1);
    // find the substring
    String json = input.substring(startIndex + 7, endIndex);
    // scrub the string to make it json decodable
    json = json.replaceAll('\\n', '');
    json = json.replaceAll('\\', '');
    // then extract and parse
    try {
      return (jsonDecode(json), input.substring(endIndex + 1));
    } catch (e) {
      return null;
    }
  }

  String getMoreAssessmentsPrompt(AssessmentProvider assessmentProvider) {
    var typeMap = assessmentProvider.getQuestionTypeCount();
    int multipleChoiceCount = typeMap['Multiple Choice']!;
    int shortAnswerCount = typeMap['Short Answer']!;
    int essayCount = typeMap['Essay']!;
    int totalCount = multipleChoiceCount + shortAnswerCount + essayCount;
    return 'Please generate as many complete assessments as you can with $totalCount questions each based on the previous assessments you sent me. Do not repeat questions. Do use the same format.';
  }

  void addMessage(String input) {
    Map<String, dynamic> json = jsonDecode(input);
    String message = json['choices'][0]['message']['content'] ?? '';
    messages.add({'role': 'assistant', 'content': message});
  }
}
