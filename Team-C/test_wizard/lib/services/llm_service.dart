import 'package:http/http.dart' as http;
import 'dart:convert';

class LLMService {
  String url = 'https://api.perplexity.ai/chat/completions';
  String apiKey = const String.fromEnvironment('API_KEY');
  http.Response? response;

  LLMService();

  Future<http.Response> sendRequest(String prompt) {
    return http.post(
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
            'content': 'You are a teacher creating tests for your students.',
          },
          {
            'role': 'user',
            'content': prompt,
          }
        ]
      }),
    );
  }
}
