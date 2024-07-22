import 'package:http/http.dart' as http;

// Class to establish an HTTP network request.
class HttpConnect {

  Future<http.Response> post(String url) {
    return http.get(Uri.parse(url));
  }
}