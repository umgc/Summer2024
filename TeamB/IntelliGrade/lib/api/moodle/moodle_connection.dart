import 'api_response.dart';

abstract class MoodleConnection {
  Future<ApiResponse<List<dynamic>>> getCourses();
  Future<ApiResponse<Map<String, dynamic>>> getUser(int userId);
  Future<ApiResponse<void>> uploadAssessment(Map<String, dynamic> assessmentData);
  Future<ApiResponse<Map<String, dynamic>>> getAssessment(int assessmentId);
}