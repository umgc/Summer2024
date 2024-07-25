import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserProvider extends ChangeNotifier {
  bool isLoggedInToMoodle;
  String? token;

  UserProvider({
    this.isLoggedInToMoodle = false,
  });

  Future<void> loginToMoodle(String username, String password, String moodleUrl) async {
    // final url = Uri.parse('http://localhost/login/token.php?username=$username&password=$password&service=moodle_mobile_app');
    if (username == "" || password == "" || moodleUrl == "") {
      throw Exception('Username, password and URL are required');
    }
    final url = Uri.parse('$moodleUrl/login/token.php?username=$username&password=$password&service=moodle_mobile_app');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      token = responseData['token'];
      if (token != "" && token != null) {
        isLoggedInToMoodle = true;
      }
      notifyListeners();
    } else {
      throw Exception('Failed to login to Moodle');
    }
  }
}
