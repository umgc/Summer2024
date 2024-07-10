import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test_wizard/services/llm_service.dart';

void main() {
  group('LLM Service', () {
    test('constructor correctly instantiates class', () {
      final llm = LLMService();
      expect(llm.url, 'https://api.perplexity.ai/chat/completions');
      expect(llm.apiKey, const String.fromEnvironment('API_KEY'));
    });

    // mock successful response from AI, probably not what it actually looks like
    final response = {
      'questions': [
        {
          'question': 'What is the powerhouse of the cell',
          'type': 'multiple choice',
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
  });
}
