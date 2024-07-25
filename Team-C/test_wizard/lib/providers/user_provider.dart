import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProvider extends ChangeNotifier {
  bool isLoggedInToMoodle;
  String? token;
  List<dynamic> courses = [];

  UserProvider({
    this.isLoggedInToMoodle = false,
  });

  Future<void> loginToMoodle(String username, String password) async {
    // Get token from Moodle
    final url = Uri.parse('http://localhost/login/token.php?username=$username&password=$password&service=moodle_mobile_app');
    final response = await http.get(url);
    // If successful, set token and logged in flag
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      token = responseData['token'];
      isLoggedInToMoodle = true;
      notifyListeners();
      // Fetch all courses from Moodle
      await fetchCourses();
    } else {
      throw Exception('Failed to login to Moodle');
    }
  }

  Future<void> fetchCourses() async {
    // Get courses from Moodle
    final url = Uri.parse('http://localhost/webservice/rest/server.php?wstoken=$token&moodlewsrestformat=json&wsfunction=core_course_get_courses');
    final response = await http.get(url);
    // If successful, set courses
    if (response.statusCode == 200) {
      courses = (json.decode(response.body) as List<dynamic>)
          .where((course) => course['categoryid'] == 1)
          .toList();
      notifyListeners();
    } else {
      throw Exception('Failed to fetch courses');
    }
  }
}
