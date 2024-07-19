import 'api_response.dart';
import 'api_client.dart';
import 'dart:convert';
import 'moodle_connection.dart';

class MoodleConnectionImpl implements MoodleConnection {
  String _moodleUrl = '';
  String _token = '';
  String _baseUrl = '';

  @override
  void setMoodleUrl(String moodleUrl, String token, String baseUrl) {
    _moodleUrl = moodleUrl;
    _token = token;
    _baseUrl = baseUrl;
  }

  @override
  Future<ApiResponse<dynamic>> processRequest(Map<String, dynamic> requestParams) async {
    requestParams['wstoken'] = _token;
    requestParams['moodlewsrestformat'] = 'json';

    final response = await ApiClient(baseUrl: _baseUrl, token: _token).post(_moodleUrl, body: requestParams);

    if (response.statusCode == 200) {
      return ApiResponse.success(json.decode(response.body));
    } else {
      return ApiResponse.error('Error: ${response.statusCode}');
    }
  }
}
