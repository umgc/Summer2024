import 'api_client.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MoodleAccessor {
  final ApiClient apiClient;

  MoodleAccessor({required this.apiClient});

  Future<void> createUser(Map<String, dynamic> userData) async {
    final endpoint = '/webservice/rest/server.php?wstoken=${apiClient.token}&wsfunction=core_user_create_users&moodlewsrestformat=json';
    await apiClient.post(endpoint, body: userData);
  }

  Future<List<dynamic>> getCourses() async {
    final endpoint = '/webservice/rest/server.php?wstoken=${apiClient.token}&wsfunction=core_course_get_courses&moodlewsrestformat=json';
    final response = await apiClient.get(endpoint);
    final jsonResponse = json.decode(response.body);
    if (jsonResponse is List) {
      return jsonResponse;
    } else {
      throw Exception('Failed to load courses');
    }
  }

  Future<Map<String, dynamic>> getUser(int userId) async {
    final endpoint = '/webservice/rest/server.php';
    final body = {
      'wstoken': apiClient.token,
      'wsfunction': 'core_user_get_users_by_field',
      'moodlewsrestformat': 'json',
      'field': 'id',
      'values': [userId.toString()],
    };
    final response = await apiClient.post(endpoint, body: body);
    final jsonResponse = json.decode(response.body);
    if (jsonResponse is List && jsonResponse.isNotEmpty) {
      return jsonResponse[0];
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<List<Map<String, dynamic>>> exportQuestions(int quizId) async {
    final endpoint = '/webservice/rest/server.php';
    final body = {
      'wstoken': apiClient.token,
      'wsfunction': 'mod_quiz_get_questions',
      'moodlewsrestformat': 'json',
      'quizid': quizId.toString(),
    };
    final response = await apiClient.post(endpoint, body: body);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is Map<String, dynamic> && jsonResponse['questions'] != null) {
        return (jsonResponse['questions'] as List)
            .map((question) => question as Map<String, dynamic>)
            .toList();
      } else {
        throw Exception('Failed to export questions');
      }
    } else {
      throw Exception('Failed to export questions: ${response.statusCode}');
    }
  }

  Future<String> login(String username, String password) async {
    final response = await http.get(
      Uri.parse('${apiClient.baseUrl}/login/token.php?username=$username&password=$password&service=moodle_mobile_app')
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['token'] != null) {
        return jsonResponse['token'];
      } else {
        throw Exception('Failed to retrieve token');
      }
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }
}
