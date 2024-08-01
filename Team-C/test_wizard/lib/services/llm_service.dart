import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:test_wizard/models/assessment.dart';
import 'package:test_wizard/providers/assessment_provider.dart';
import 'package:test_wizard/services/document_directory_service.dart';

class LLMService {
  final DocumentDirectoryService dds=DocumentDirectoryService('VeryDescriptivePareseName');
  final String _url = 'https://api.perplexity.ai/chat/completions';
  final String _apiKey = '';
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

  (List<Map<String, dynamic>>?, String)? extractAssessments(String input) {
    //String testOutputString = '[{"multipleChoice": [{"QUESTION": "Who first ruled early Rome?","OPTIONS": ["Etruscan kings", "military consuls", "Roman senators", "plebeian assemblies"],"ANSWER": "Etruscan kings"},{"QUESTION": "According to legend, events on a visit to the oracle at Delphi determined","OPTIONS": ["where Rome should be built", "who would govern Rome next", "how Rome could start colonies", "when Rome would write its laws"],"ANSWER": "who would govern Rome next"},{"QUESTION": "In the Roman Republic, patricians referred to","OPTIONS": ["every adult male citizen", "everyone except slaves", "wealthy landowning families", "people with Greek ancestors"],"ANSWER": "wealthy landowning families"},{"QUESTION": "Why were plebeians unhappy when the Roman Republic was first set up?","OPTIONS": ["They had lost the right to vote", "They preferred living in an empire", "They had no say in making the laws", "They preferred being ruled by a king"],"ANSWER": "They had no say in making the laws"}]},{"multipleChoice": [{"QUESTION": "Who set up the Roman Republic?","OPTIONS": ["plebeians", "patricians", "Greek settlers", "Etruscan princes"],"ANSWER": "patricians"},{"QUESTION": "How did plebeians serve the republic during its early years?","OPTIONS": ["as priests", "as soldiers", "as foreign advisers", "as government officials"],"ANSWER": "as soldiers"},{"QUESTION": "In the Roman Republic, who might have spoken these words?","OPTIONS": ["a scribe", "a consul", "a tribune", "a senator"],"ANSWER": "a tribune"},{"QUESTION": "What was one major job of the consuls?","OPTIONS": ["to command the army", "to choose the lawmakers", "to perform religious rituals", "to construct public buildings"],"ANSWER": "to command the army"}]},{"multipleChoice": [{"QUESTION": "What event belongs in the blank space on the timeline?","OPTIONS": ["Roman Empire falls", "Plebeians elect a leader", "Plebeians refuse to fight", "Etruscans return to power"],"ANSWER": "Plebeians refuse to fight"},{"QUESTION": "What was a result of the Conflict of the Orders?","OPTIONS": ["Plebeians lost the right to vote", "Patricians gave up some power", "Romans defeated the Greek navy", "Etruscans won control over Rome"],"ANSWER": "Patricians gave up some power"},{"QUESTION": "How could a Roman become a tribune?","OPTIONS": ["have a consul appoint him", "win the favor of the senators", "inherit the job from his father", "get the plebeians to elect him"],"ANSWER": "get the plebeians to elect him"},{"QUESTION": "What was a likely effect of Harsau2019s speeches?","OPTIONS": ["stir up the plebeians to rebellion", "increase conflict between patricians and plebeians", "limit the power of the consuls", "put the plebeians in charge of the government"],"ANSWER": "stir up the plebeians to rebellion"}]},{"multipleChoice": [{"QUESTION": "Who first ruled early Rome?","OPTIONS": ["Etruscan kings", "military consuls", "Roman senators", "plebeian assemblies"],"ANSWER": "Etruscan kings"},{"QUESTION": "According to legend, events on a visit to the oracle at Delphi determined","OPTIONS": ["where Rome should be built", "who would govern Rome next", "how Rome could start colonies", "when Rome would write its laws"],"ANSWER": "who would govern Rome next"},{"QUESTION": "In the Roman Republic, patricians referred to","OPTIONS": ["every adult male citizen", "everyone except slaves", "wealthy landowning families", "people with Greek ancestors"],"ANSWER": "wealthy landowning families"},{"QUESTION": "Why were plebeians unhappy when the Roman Republic was first set up?","OPTIONS": ["They had lost the right to vote", "They preferred living in an empire", "They had no say in making the laws", "They preferred being ruled by a king"],"ANSWER": "They had no say in making the laws"}]}]';
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
    json = json.replaceAll('  ', '');
    dds.writeToFile(json);
    // then extract and parse
    try {
      return (jsonDecode(json), input.substring(endIndex + 1));
    } catch (e) {
      return null;
    }
  }

  String getMoreAssessmentsPrompt(AssessmentProvider assessmentProvider) {
    var typeMap = assessmentProvider.getQuestionTypeCount();
    int multipleChoiceCount = typeMap['multipleChoice']!;
    int shortAnswerCount = typeMap['shortAnswer']!;
    int essayCount = typeMap['essay']!;
    int totalCount = multipleChoiceCount + shortAnswerCount + essayCount;
    return 'Please generate as many complete assessments as you can with $totalCount questions each based on the previous assessments you sent me. Do not repeat questions. Do use the same format.';
  }

  void addMessage(String input) {
    Map<String, dynamic> json = jsonDecode(input);
    String message = json['choices'][0]['message']['content'] ?? '';
    messages.add({'role': 'assistant', 'content': message});
  }
}
