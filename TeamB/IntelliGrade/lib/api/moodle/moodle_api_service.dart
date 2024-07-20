import 'api_response.dart';
import 'moodle_accessor.dart';

class MoodleAPIService {
  final MoodleAccessor moodleAccessor;

  MoodleAPIService(this.moodleAccessor);

  Future<ApiResponse<List<dynamic>>> getCourses() async {
    try {
      final courses = await moodleAccessor.getCourses();
      return ApiResponse<List<dynamic>>(
        success: true,
        data: courses,
        message: 'Courses fetched successfully',
      );
    } catch (e) {
      return ApiResponse<List<dynamic>>(
        success: false,
        data: [],
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> getUser(int userId) async {
    try {
      final user = await moodleAccessor.getUser(userId);
      return ApiResponse<Map<String, dynamic>>(
        success: true,
        data: user,
        message: 'User fetched successfully',
      );
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        data: {},
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<void>> uploadAssessment(Map<String, dynamic> assessmentData) async {
    try {
      await moodleAccessor.uploadAssessment(assessmentData);
      return ApiResponse<void>(
        success: true,
        data: null,
        message: 'Assessment uploaded successfully',
      );
    } catch (e) {
      return ApiResponse<void>(
        success: false,
        data: null,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> getAssessment(int assessmentId) async {
    try {
      final assessment = await moodleAccessor.getAssessment(assessmentId) as Map<String, dynamic>;
      return ApiResponse<Map<String, dynamic>>(
        success: true,
        data: assessment,
        message: 'Assessment fetched successfully',
      );
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        success: false,
        data: {},
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<void>> importQuestions(Map<String, dynamic> questionData) async {
    try {
      await moodleAccessor.importQuestions(questionData);
      return ApiResponse<void>(
        success: true,
        data: null,
        message: 'Questions imported successfully',
      );
    } catch (e) {
      return ApiResponse<void>(
        success: false,
        data: null,
        message: e.toString(),
      );
    }
  }

  Future<ApiResponse<List<Map<String, dynamic>>>> exportQuestions(int quizId) async {
    try {
      final questions = await moodleAccessor.exportQuestions(quizId);
      return ApiResponse<List<Map<String, dynamic>>>(
        success: true,
        data: questions,
        message: 'Questions exported successfully',
      );
    } catch (e) {
      return ApiResponse<List<Map<String, dynamic>>>(
        success: false,
        data: [],
        message: e.toString(),
      );
    }
  }
}
