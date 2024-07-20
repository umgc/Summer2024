import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiClient {
  final String baseUrl;
  final String token;

  ApiClient({required this.baseUrl, required this.token});

  Future<http.Response> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return _processResponse(response);
  }

  Future<http.Response> post(String endpoint, {required Map<String, dynamic> body}) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  http.Response _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}

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

  Future<Map<String, dynamic>> processRequest(Map<String, dynamic> requestData) async {
    final response = await apiClient.post('/webservice/rest/server.php', body: requestData);
    final jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  Future<void> importQuestions(Map<String, dynamic> questionData) async {
    final endpoint = '/webservice/rest/server.php?wstoken=${apiClient.token}&wsfunction=mod_quiz_import_questions&moodlewsrestformat=json';
    await apiClient.post(endpoint, body: questionData);
  }

  Future<Map<String, dynamic>> getAssessment(int assessmentId) async {
    final endpoint = '/webservice/rest/server.php?wstoken=${apiClient.token}&wsfunction=mod_quiz_get_quizzes_by_courses&moodlewsrestformat=json';
    final body = {
      'courseids': [assessmentId]
    };
    final response = await apiClient.post(endpoint, body: body);
    final jsonResponse = json.decode(response.body);
    if (jsonResponse is List && jsonResponse.isNotEmpty) {
      return jsonResponse[0];
    } else {
      throw Exception('Failed to load assessment');
    }
  }

  Future<void> uploadAssessment(Map<String, dynamic> assessmentData) async {
    final endpoint = '/webservice/rest/server.php?wstoken=${apiClient.token}&wsfunction=mod_quiz_create_quizzes&moodlewsrestformat=json';
    await apiClient.post(endpoint, body: assessmentData);
  }

  Future<List<Map<String, dynamic>>> exportQuestions(int quizId) async {
    final endpoint = '/webservice/rest/server.php?wstoken=${apiClient.token}&wsfunction=mod_quiz_get_questions_by_quiz_id&moodlewsrestformat=json';
    final body = {
      'quizid': quizId.toString()
    };
    final response = await apiClient.post(endpoint, body: body);
    final jsonResponse = json.decode(response.body);
    if (jsonResponse is List) {
      return List<Map<String, dynamic>>.from(jsonResponse);
    } else {
      throw Exception('Failed to export questions');
    }
  }
}
