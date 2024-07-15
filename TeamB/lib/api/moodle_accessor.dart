import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_response.dart';

class MoodleAccessor {
  final String baseUrl;
  final String token;

  MoodleAccessor({required this.baseUrl, required this.token});

  Future<ApiResponse<Map<String, dynamic>>> createUser(Map<String, dynamic> userData) async {
    final urlParameters = {
      'users[0][username]': 'testusername1',
      'users[0][password]': 'testpassword1',
      'users[0][firstname]': 'testfirstname1',
      'users[0][lastname]': 'testlastname1',
      'users[0][email]': 'testemail1@moodle.com',
      // Add more parameters as needed
    };

    final response = await _postRequest(
      'webservice/rest/server.php',
      {
        'wstoken': token,
        'wsfunction': 'core_user_create_users',
        'moodlewsrestformat': 'json',
        ...urlParameters,
      },
      (json) => json as Map<String, dynamic>,
    );

    return response;
  }

  Future<ApiResponse<T>> _postRequest<T>(
    String endpoint,
    Map<String, dynamic> body,
    T Function(Object? json) fromJsonT,
  ) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body.entries.map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value)}').join('&'),
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
}
