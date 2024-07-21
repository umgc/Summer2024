import 'api_response.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'moodle_connection.dart';

class MoodleConnectionImpl extends MoodleConnection {
  String _moodleUrl = '';
  String _token = '';
  String _siteUrl = '';

  @override
  void setMoodleUrl(String url, String token, String siteUrl) {
    _moodleUrl = url;
    _token = token;
    _siteUrl = siteUrl;
  }

  @override
  Future<ApiResponse<dynamic>> processRequest(Map<String, dynamic> requestParams) async {
    requestParams['wstoken'] = _token;
    requestParams['moodlewsrestformat'] = 'json';

    final response = await http.post(
      Uri.parse(_moodleUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: requestParams,
    );

    if (response.statusCode == 200) {
      return ApiResponse<dynamic>(
        success: true,
        data: json.decode(response.body),
        message: 'Success',
      );
    } else {
      return ApiResponse<dynamic>(
        success: false,
        data: null,
        message: 'Error: ${response.statusCode}',
      );
    }
  }
}
