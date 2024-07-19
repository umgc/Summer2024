import 'package:flutter_test/flutter_test.dart';
import 'package:teamb_intelligrade/api/moodle_api_service.dart';
import 'package:teamb_intelligrade/api/moodle_connection.dart';
import 'package:teamb_intelligrade/api/api_response.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ConcreteMoodleConnection extends MoodleConnection {
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
      return ApiResponse.success(json.decode(response.body));
    } else {
      return ApiResponse.error('Error: ${response.statusCode}');
    }
  }
}

void main() {
  late MoodleAPIService moodleAPIService;
  late ConcreteMoodleConnection moodleConnection;

  setUp(() {
    moodleConnection = ConcreteMoodleConnection();
    moodleConnection.setMoodleUrl(
      'http://100.25.213.47/webservice/rest/server.php',
      '4e825999a41297ea35dbddc465d92296',
      'http://100.25.213.47',
    );
    moodleAPIService = MoodleAPIService(moodleConnection);
  });

  test('Get Courses', () async {
    final response = await moodleAPIService.getCourses();
    expect(response, isA<ApiResponse<List<dynamic>>>());
  });

  test('Import Questions', () async {
    final questionData = {
      'questions': [
        {
          'category': 'testcategory',
          'questiontext': 'What is the capital of France?',
          'qtype': 'shortanswer',
          'answer': 'Paris'
        }
      ]
    };
    final response = await moodleAPIService.importQuestions(questionData);
    expect(response, isA<ApiResponse<void>>());
  });
}
