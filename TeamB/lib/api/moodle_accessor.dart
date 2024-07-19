import 'api_client.dart';
import 'dart:convert';

class MoodleAccessor {
  final ApiClient apiClient;

  MoodleAccessor({required this.apiClient});

  Future<void> createUser(Map<String, dynamic> userData) async {
    final endpoint = '/webservice/rest/server.php?wstoken=${apiClient.token}&wsfunction=core_user_create_users&moodlewsrestformat=json';
    await apiClient.post(endpoint, body: userData);
  }

  Future<List<dynamic>> getCourses() async {
    final endpoint = 'webservice/rest/server.php?wstoken=${apiClient.token}&wsfunction=core_course_get_courses&moodlewsrestformat=json';
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
}
