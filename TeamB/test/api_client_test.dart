import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:teamb_intelligrade/api/api_client.dart';
import 'package:http/testing.dart';
import 'dart:convert';

void main() {
  group('ApiClient', () {
    late ApiClient apiClient;
    const baseUrl = 'http://example.com';
    const token = 'dummyToken';

    setUp(() {
      apiClient = ApiClient(baseUrl: baseUrl, token: token);
    });

    test('GET request returns success', () async {
      final client = MockClient((request) async {
        return http.Response(jsonEncode({'data': 'test'}), 200);
      });
      apiClient = ApiClient(baseUrl: baseUrl, token: token, client: client);

      final response = await apiClient.get('/test');
      expect(response.statusCode, 200);
      expect(jsonDecode(response.body), {'data': 'test'});
    });

    test('POST request returns success', () async {
      final client = MockClient((request) async {
        return http.Response(jsonEncode({'data': 'test'}), 200);
      });
      apiClient = ApiClient(baseUrl: baseUrl, token: token, client: client);

      final response = await apiClient.post('/test', body: {'key': 'value'});
      expect(response.statusCode, 200);
      expect(jsonDecode(response.body), {'data': 'test'});
    });

    test('GET request throws exception on failure', () async {
      final client = MockClient((request) async {
        return http.Response('Not Found', 404);
      });
      apiClient = ApiClient(baseUrl: baseUrl, token: token, client: client);

      expect(() async => await apiClient.get('/test'), throwsException);
    });

    test('POST request throws exception on failure', () async {
      final client = MockClient((request) async {
        return http.Response('Not Found', 404);
      });
      apiClient = ApiClient(baseUrl: baseUrl, token: token, client: client);

      expect(() async => await apiClient.post('/test', body: {'key': 'value'}), throwsException);
    });
  });
}
