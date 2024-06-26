import 'package:http/http.dart' as http;
import 'dart:convert';

class LLMService {
  String
      url; // would this come from a provider? As in llm = new LLMProvider(), then llm.url, llm.apiKey, etc.
  String apiKey = const String.fromEnvironment('API_KEY');

  LLMService({
    this.url = 'https://api.perplexity.ai/chat/completions',
  }); // or this.llm = new LLMProvider?

  Future<http.Response> sendRequest(String prompt) {
    return http.post(
      Uri.parse(url),
      headers: <String, String>{
        // or llm.generateHeaders()?
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey'
      },
      body: jsonEncode({
        // or llm.generateBody()?
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
