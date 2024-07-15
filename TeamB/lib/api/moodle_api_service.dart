import 'dart:convert';

import 'api_response.dart';

class MoodleApiService {
  final String baseUrl;
  final String token;

  MoodleApiService({required this.baseUrl, required this.token});

  Future<ApiResponse<T>> _postRequest<T>(
      String endpoint, Map<String, dynamic> body, T Function(Object? json) fromJsonT) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return ApiResponse.fromJson(jsonResponse, fromJsonT);
    } else {
      return ApiResponse<T>(
        success: false,
        data: null as T,
        message: 'Error: ${response.statusCode}',
      );
    }
  }

  Future<ApiResponse<T>> _getRequest<T>(
      String endpoint, T Function(Object? json) fromJsonT) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return ApiResponse.fromJson(jsonResponse, fromJsonT);
    } else {
      return ApiResponse<T>(
        success: false,
        data: null as T,
        message: 'Error: ${response.statusCode}',
      );
    }
  }

  Future<ApiResponse<List<dynamic>>> getCourses() async {
    return _getRequest<List<dynamic>>(
      'webservice/rest/server.php?wstoken=$token&wsfunction=core_course_get_courses&moodlewsrestformat=json',
      (json) => json as List<dynamic>,
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> getUser(int userId) async {
    return _postRequest<Map<String, dynamic>>(
      'webservice/rest/server.php',
      {
        'wstoken': token,
        'wsfunction': 'core_user_get_users_by_field',
        'moodlewsrestformat': 'json',
        'field': 'id',
        'values': [userId.toString()],
      },
      (json) => json as Map<String, dynamic>,
    );
  }
}
