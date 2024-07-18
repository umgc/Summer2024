import 'package:http/http.dart' as http;

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  final http.Client client;

  factory HttpClient() {
    return _instance;
  }

  HttpClient._internal() : client = http.Client();

  Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    return await client.get(Uri.parse(url), headers: headers);
  }

  Future<http.Response> post(String url, {Map<String, String>? headers, Object? body}) async {
    return await client.post(Uri.parse(url), headers: headers, body: body);
  }

  

  void dispose() {
    client.close();
  }
}