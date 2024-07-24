import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:test_wizard/models/assessment.dart';
import 'package:test_wizard/providers/assessment_state.dart';

class LLMService {
  String url = 'https://api.perplexity.ai/chat/completions';
  String apiKey = const String.fromEnvironment('API_KEY');

  LLMService();

  String getAssessmentAsJson(Assessment assessment) {
    JsonEncoder encoder = const JsonEncoder();
    var map = {
      "multipleChoice": [],
      "math": [],
      "shortAnswer": [],
      "essay": []
    };
    for (var question in assessment.questions) {
      switch (question.questionType) {
        case "Multiple Choice":
          map['multipleChoice']!.add({"QUESTION": question.questionText});
          break;
        case "Short Answer":
          map['shortAnswer']!.add({"QUESTION": question.questionText});
          break;
        case "Essay":
          map['essay']!.add({"QUESTION": question.questionText});
          break;
        default:
          continue;
      }
    }
    try {
      String json = encoder.convert(map);
      return json;
    } catch (e) {
      return '';
    }
  }

  String buildPrompt(
    String topic,
    AssessmentState state,
  ) {
    var typeMap = state.getQuestionTypeCount();
    int multipleChoiceCount = typeMap['Multiple Choice']!;
    int shortAnswerCount = typeMap['Short Answer']!;
    int essayCount = typeMap['Essay']!;
    int totalCount = multipleChoiceCount + shortAnswerCount + essayCount;
    /*Example Prompt
    Please generate <number of assessments> <assessment types> based on the following <assessment type>. This quiz is about <description>. Provide the answers in a json and in the following format:
    QUESTION:
    ANSWER:
    
    Check your answers to ensure they are correct. Do not provide the work checking in your response but edit the JSON with the correct answer if you find errors. Do not include any questions that are copied directly from the internet.
    */

    //TODO: identify how to add focus to the prompt.
    return '''Please generate as many complete assessments as you can with $totalCount questions each based on the following assessment. This assessment is about the subject $topic. Each assessment should be very similar to the original assessment and include $multipleChoiceCount multiple choice questions, 0 math questions, $shortAnswerCount short answer questions and $essayCount essay questions. Essay questions should instead include a grading rubric. Provide each assessment formatted as its own json. 
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
    ${getAssessmentAsJson(state.assessment)}''';
  }

  Future<http.Response> sendRequest(http.Client httpClient, String prompt) {
    return httpClient.post(
      Uri.parse(url),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey'
      },
      body: jsonEncode({
        'model': 'llama-3-sonar-small-32k-online',
        'messages': [
          {
            'role': 'system',
            'content': // the system prompt is something that gives the AI context into the type of job it will perform.
                'You are an assessment generator that generates assessments based on given criteria. You only return the format specified in the prompt.',
          },
          {
            'role':
                'user', // the user prompt is something that gives the AI context into what specific job it will perform.
            'content': prompt,
          }
        ]
      }),
    );
  }
}
