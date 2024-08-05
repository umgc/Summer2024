import 'dart:io';
import 'dart:convert';

import '../lib/llm_api.dart';
// import 'package:dart_ai_interface/llm_api.dart';
import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:dart_openai/dart_openai.dart';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

const _hostname = 'localhost';
final env = DotEnv(includePlatformEnvironment: true)..load();
final apiKey = /* env['OPENAI_API_KEY']; */ env['PERPLEXITY_API_KEY'];

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  // final ip = InternetAddress.anyIPv4;

  final app = Router();
  // ignore: implicit_call_tearoffs
  Router router = LlmApi(apiKey!).router;
  app.mount('/api/', router.call);

  // Configure a pipeline that logs requests.
  final handler =
      Pipeline().addMiddleware(logRequests()).addHandler(router.call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8000');
  final server = await serve(handler, _hostname /* ip */, port);
  print('Server at http://${server.address.host}:${server.port}');
}
