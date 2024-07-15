import 'package:http/http.dart' as http;
import 'dart:convert';

class LLMService {
  String url = 'https://api.perplexity.ai/chat/completions';
  String apiKey = const String.fromEnvironment('API_KEY');

  LLMService();

  String buildPompt(int numberOfAssessments, String assessmentType, String subject, String topic){
    /*Example Prompt
    Please generate <number of assessments> <assessment types> based on the following <assessment type>. This quiz is about <description>. Provide the answers in a json and in the following format:
    QUESTION:
    ANSWER:
    
    Check your answers to ensure they are correct. Do not provide the work checking in your response but edit the JSON with the correct answer if you find errors. Do not include any questions that are copied directly from the internet.
    */

    //todo: identify how to add focus to the prompt. 
    return 'Please generate $numberOfAssessments $assessmentType based on the following $assessmentType. This quiz is about the subject $subject, specifically around the topic of $topic. Provide the answers in a json and in the following format: \nQUESTION: \nANSWER: . \nCheck your answers to ensure they are correct. Do not provide the work checking in your response but edit the JSON with the correct answer if you find errors. Do not include any questions that are copied directly from the internet.';
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
            'content': '${prompt}',
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
