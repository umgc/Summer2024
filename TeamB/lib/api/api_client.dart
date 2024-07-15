import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final Map<String, String> headers;

  ApiClient({required this.baseUrl, this.headers = const {}});

  Future<http.Response> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint'), headers: headers);
    return _processResponse(response);
  }

  Future<http.Response> post(String endpoint, {required Map<String, dynamic> body}) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: jsonEncode(body),
    );
    return _processResponse(response);
  }

  http.Response _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }
}
