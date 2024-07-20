import 'api_response.dart';

abstract class MoodleConnection {
  void setMoodleUrl(String url, String token, String siteUrl);
  Future<ApiResponse<dynamic>> processRequest(Map<String, dynamic> requestParams);
}
