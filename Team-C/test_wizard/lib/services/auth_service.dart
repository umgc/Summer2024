import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "https://testwizard.moodlecloud.com";
  final String loginEndpoint = "/login/token.php";
  final String service = "moodle_mobile_app";

  Future<String?> authenticate(String username, String password) async {
    final url = Uri.parse('$baseUrl$loginEndpoint?username=$username&password=$password&service=$service');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['error'] != null) {
        throw Exception(data['error']);
      }
      final token = data['token'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      return token;
    } else {
      throw Exception('Failed to authenticate');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
