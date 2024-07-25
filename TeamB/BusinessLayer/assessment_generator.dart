import 'assessment.dart';

class AssessmentGenerator {
  Assessment generateAssessment() {
    return Assessment();
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'assessment.dart';
import 'question.dart';

class AssessmentGenerator {
  final String serverUrl;

  AssessmentGenerator({required this.serverUrl});

  Future<Assessment> generateAssessment(String queryPrompt) async {
    final response = await http.post(
      Uri.parse('$serverUrl/generateAssessment'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'QueryPrompt': queryPrompt},
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final aiResponse = responseBody['assessment'];
      return Assessment.fromAIResponse(aiResponse);
    } else {
      throw Exception('Failed to generate assessment');
    }
  }
}