import 'dart:io';
import 'dart:convert';

import 'package:dart_ai_interface/llm_api.dart';
import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:dart_openai/dart_openai.dart';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:dart_ai_interface/llm_api.dart';

const _hostname = 'localhost';
final env = DotEnv(includePlatformEnvironment: true)..load();
final apiKey = /* env['OPENAI_API_KEY']; */ env['PERPLEXITY_API_KEY'];

// // Configure routes.
// final _router = Router()
//   ..get('/', _rootHandler)
//   ..get('/echo/<message>', _echoHandler)
//   ..post('/api/', _apiHandler);

// Response _rootHandler(Request req) {
//   return Response.ok(
//       "IntelliGrade's AI Interface Server has started Successfully !\n");
// }

// Response _echoHandler(Request request) {
//   final message = request.params['message'];
//   return Response.ok('$message\n');
// }

// Future<Response> _apiHandler(Request request) async {
//   final uri = Uri(query: await request.readAsString());
//   final formData = uri.queryParameters;
//   print(formData);
//   // print("formData['QueryPrompt']: ${formData['QueryPrompt']}");

//   final queryPrompt = formData['QueryPrompt'];
//   var resp = "";

//   // use the following test query so Perplexity doesn't charge
//   // 'How many stars are there in our galaxy?'
//   if (queryPrompt!.isNotEmpty) {
//     resp = await queryAI(queryPrompt);
//   }

//   return Response.ok(
//     '''You sent:
//     $formData

//     AI Response:
//     $resp
//     ''',
//     headers: {'Content-type': 'text/plain'},
//     // headers: {'Content-type': 'application/json'},
//   );
// }

// Future<String> queryAI(String query) async {
//   // const prompt1 = 'How many stars are there in our galaxy?';
//   final postHeaders = getPostHeaders();
//   final postBody = getPostBody(query);
//   final httpPackageUrl = getPostUrl();
//   // print("In queryAI !!");
//   // print('The url : $httpPackageUrl');

//   final httpPackageRespString =
//       await postMessage(httpPackageUrl, postHeaders, postBody);

//   final httpPackageResponseJson = convertHttpRespToJson(httpPackageRespString);

//   // print(httpPackageRespString);
//   var retResponse = "";
//   for (var respChoice in httpPackageResponseJson['choices']) {
//     retResponse += respChoice['message']['content'];
//   }

//   print(retResponse);

//   return retResponse;
// }

// Map<String, dynamic> convertHttpRespToJson(String httpResponseString) {
//   return (json.decode(httpResponseString) as Map<String, dynamic>);
// }

// ///
// ///
// ///
// String getPostBody(String prompt) {
//   return jsonEncode({
//     // 'model': 'llama-3-sonar-large-32k-online',
//     'model': 'llama-3-sonar-large-32k-chat',
//     'messages': [
//       {'role': 'system', 'content': 'Be precise and concise'},
//       {'role': 'user', 'content': prompt}
//     ]
//   });
// }

// ///
// Map<String, String> getPostHeaders() {
//   return ({
//     'accept': 'application/json',
//     'content-type': 'application/json',
//     'authorization': 'Bearer $apiKey',
//   });
// }

// ///
// Uri getPostUrl() => Uri.https('api.perplexity.ai', '/chat/completions');

// ///
// Future<String> postMessage(
//     Uri url, Map<String, String> postHeaders, Object postBody) async {
//   final httpPackageResponse =
//       await http.post(url, headers: postHeaders, body: postBody);

//   if (httpPackageResponse.statusCode != 200) {
//     print('Failed to retrieve the http package!');
//     print('statusCode :  ${httpPackageResponse.statusCode}');
//     return "";
//   }

//   // print(httpPackageResponse.body);

//   return httpPackageResponse.body;
// }

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
