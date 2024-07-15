import 'api_client.dart';
import 'moodle_accessor.dart';

class MoodleConnectionFactory {
  final String baseUrl;
  final String token;

  MoodleConnectionFactory({required this.baseUrl, required this.token});

  MoodleAccessor createConnection() {
    final apiClient = ApiClient(baseUrl: baseUrl, headers: {'Authorization': token});
    return MoodleAccessor(apiClient);
  }
}