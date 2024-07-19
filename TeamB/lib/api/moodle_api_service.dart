import 'moodle_connection.dart';
import 'api_response.dart';

class MoodleAPIService {
  final MoodleConnection _moodleConnection;

  MoodleAPIService(this._moodleConnection);

  Future<ApiResponse<dynamic>> getCourses() async {
    final requestData = {
      'wsfunction': 'core_course_get_courses',
    };
    return _moodleConnection.processRequest(requestData);
  }

  Future<ApiResponse<void>> importQuestions(Map<String, dynamic> questionData) async {
    final requestData = {
      'wsfunction': 'mod_quiz_import_questions',
      'questions': questionData,
    };
    return _moodleConnection.processRequest(requestData);
  }

}
