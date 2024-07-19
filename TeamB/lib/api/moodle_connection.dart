import 'api_response.dart';

abstract class MoodleConnection {
  void setMoodleUrl(String moodleUrl, String token, String baseUrl);

  Future<ApiResponse<dynamic>> processRequest(Map<String, dynamic> requestParams);
}
