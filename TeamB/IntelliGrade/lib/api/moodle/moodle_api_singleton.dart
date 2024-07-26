import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../controller/model/beans.dart';

// Singleton class for Moodle API access.
class MoodleApiSingleton {
  static const baseUrl = 'http://100.25.213.47';
  static const serverUrl = '$baseUrl/webservice/rest/server.php?wstoken=';
  static const jsonFormat = '&moodlewsrestformat=json';
  static const errorKey = 'error';

  // The singleton instance.
  static final MoodleApiSingleton _instance = MoodleApiSingleton._internal();

  // User token is stored here.
  String? _userToken;

  // Singleton accessor.
  factory MoodleApiSingleton() {
    return _instance;
  }

  // Internal constructor.
  MoodleApiSingleton._internal();

  // Check if user has logged in (if singleton has a token).
  bool isLoggedIn() {
    return _userToken == null;
  }

  // Log in to Moodle and retrieve the user token. Throws HttpException if login failed.
  Future<void> login(String username, String password) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/login/token.php?username=$username&password=$password&service=moodle_mobile_app'
    ));
    Map<String, dynamic> data = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw HttpException(response.body);
    } else if (data.containsKey(errorKey)) {
      throw HttpException(data[errorKey]);
    }
    _userToken = data['token'];
  }

  // Log out of Moodle by deleting the stored user token.
  void logout() {
    _userToken = null;
  }

  // Get list of courses.
  Future<List<Course>> getCourses() async {
    if (_userToken == null) throw StateError('User not logged in to Moodle');

    final response = await http.get(Uri.parse(
        '$serverUrl$_userToken$jsonFormat&wsfunction=core_course_get_courses'
    ));
    if (response.statusCode != 200) {
      throw HttpException(response.body);
    }
    List<Course> courses = (jsonDecode(response.body) as List).map((i) => Course.fromJson(i)).toList();
    return courses;
  }

  // Import XML quiz into the specified course. Returns a list of IDs for newly imported questions.
  Future<void> importQuiz(String courseid, String quizXml) async {
    if (_userToken == null) throw StateError('User not logged in to Moodle');

    final http.Response response = await http.post(Uri.parse(
      '$serverUrl$_userToken$jsonFormat&wsfunction=local_quizgen_import_questions&courseid=$courseid&questionxml=$quizXml'
    ));
    if (response.statusCode != 200) {
      throw HttpException(response.body);
    }
    if (response.body.contains('error')) {
      throw HttpException(response.body);
    }
  }
}