import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test_wizard/providers/assessment_provider.dart';
import 'package:test_wizard/services/llm_service.dart';

void main() {
  group('LLM Service', () {
    // commenting this out for now
    // test('constructor correctly instantiates class', () {
    //   final llm = LLMService();
    //   expect(llm.url, 'https://api.perplexity.ai/chat/completions');
    //   expect(llm.apiKey, const String.fromEnvironment('API_KEY'));
    // });

    test('extractAssessment', () {
      String testString =
          'this is some text ```json[{"hello": "world"}]``` this is the rest';
      String broken = 'This isnt json';

      final llm = LLMService();
      var (expected, _) = llm.extractAssessments(testString) ?? (null, null);
      var (expected2, _) = llm.extractAssessments(broken) ?? (null, null);
      expect(expected, [{"hello": "world"}]);
      expect(expected2, null);
    });

    // mock successful response from AI, probably not what it actually looks like
    final response = {
      'questions': [
        {
          'question': 'What is the powerhouse of the cell',
          'type': 'multipleChoice',
          'choice1': 'mitochondria',
          'choice2': 'vacuole',
          'choice3': 'nucleus',
          'choice4': 'the limit does not exist',
          'answer': 'the limit does not exist',
        }
      ]
    };

    test('makes call to API', () async {
      final llm = LLMService();
      final mockHTTPClient = MockClient((_) async {
        return Response(jsonEncode(response), 200);
      });

      expect(llm.sendRequest(mockHTTPClient, 'this is my prompt'),
          isInstanceOf<Future<Response>>());
    });

    test('correctly builds prompt', () {
      final llm = LLMService();
      AssessmentProvider assessmentProvider = AssessmentProvider();
      String prompt = llm.buildPrompt('math', assessmentProvider, true,0,0);
      expect(prompt.startsWith('The focus of this assessment is math.'), true);
      String prompt2 = llm.buildPrompt('not math', assessmentProvider, false,0,0);
      expect(prompt2.startsWith('Please generate'), true);
    });
  });
}
