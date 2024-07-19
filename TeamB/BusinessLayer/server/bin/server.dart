import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:xml/xml.dart';
import 'package:intl/intl.dart';
import 'package:teamb_intelligrade/llm_api.dart';

const _hostname = 'localhost';
final env = DotEnv(includePlatformEnvironment: true)..load();
final apiKey = env['PERPLEXITY_API_KEY'];

// // Configure routes.
// final _router = Router()
//   ..get('/', _rootHandler)
//   ..get('/echo/<message>', _echoHandler)
//   ..post('/generateAssessment', _generateAssessmentHandler)
//   ..post('/gradeAssessment', _gradeAssessmentHandler)
//   ..post('/save', _saveHandler)
//   ..post('/download', _downloadHandler)
//   ..get('/listFiles', _listFilesHandler)
//   ..post('/getFileContent', _getFileContentHandler)
//   ..put('/updateFile', _updateFileHandler);

// Response _rootHandler(Request req) {
//   return Response.ok('Hello, World!\n');
// }

// Response _echoHandler(Request request) {
//   final message = request.params['message'];
//   return Response.ok('$message\n');
// }

// Future<Response> _generateAssessmentHandler(Request request) async {
//   final payload = await request.readAsString();
//   final formData = Uri(query: payload).queryParameters;
//   final queryPrompt = formData['QueryPrompt'] ?? '';

//   if (queryPrompt.isEmpty) {
//     return Response.badRequest(body: 'QueryPrompt is required.');
//   }

//   final aiResponse = await queryAI(queryPrompt);
//   return Response.ok(jsonEncode({'assessment': aiResponse}),
//       headers: {'Content-Type': 'application/json'});
// }

// Future<Response> _gradeAssessmentHandler(Request request) async {
//   final payload = await request.readAsString();
//   final formData = Uri(query: payload).queryParameters;
//   // Implement grading logic here

//   return Response.ok('Grading not implemented yet.');
// }

// Future<Response> _saveHandler(Request request) async {
//   final payload = await request.readAsString();
//   final formData = Uri(query: payload).queryParameters;
//   final xmlContent = formData['xmlContent'] ?? '';

//   if (xmlContent.isEmpty) {
//     return Response.badRequest(body: 'XML content is required.');
//   }

//   // Define the directory
//   final directoryPath = Directory('TeamB/BusinessLayer/SavedAssessments');
//   if (!await directoryPath.exists()) {
//     await directoryPath.create(recursive: true);
//   }

//   // Generate the file name using the current date and time
//   final now = DateTime.now();
//   final formatter = DateFormat('yyyy-MM-dd_HH-mm-ss');
//   final formattedDate = formatter.format(now);
//   final fileName = 'assessment_$formattedDate.xml';
//   final filePath = '${directoryPath.path}/$fileName';

//   // Save the file
//   final file = File(filePath);
//   await file.writeAsString(xmlContent);

//   return Response.ok('File saved as $filePath.');
// }

// Future<Response> _updateFileHandler(Request request) async {
//   final payload = await request.readAsString();
//   final formData = Uri(query: payload).queryParameters;
//   final fileName = formData['fileName'] ?? '';
//   final newXmlContent = formData['xmlContent'] ?? '';

//   if (fileName.isEmpty || newXmlContent.isEmpty) {
//     return Response.badRequest(
//         body: 'File name and new XML content are required.');
//   }

//   final filePath = 'TeamB/BusinessLayer/SavedAssessments/$fileName';
//   final file = File(filePath);

//   if (!await file.exists()) {
//     return Response.notFound('File not found.');
//   }

//   await file.writeAsString(newXmlContent);

//   return Response.ok('File updated successfully.');
// }

// Future<Response> _downloadHandler(Request request) async {
//   final payload = await request.readAsString();
//   final formData = Uri(query: payload).queryParameters;
//   final xmlContent = formData['xmlContent'] ?? '';

//   if (xmlContent.isEmpty) {
//     return Response.badRequest(body: 'XML content is required.');
//   }

//   final pdfBytes = await _generatePdfFromXml(xmlContent);

//   return Response.ok(pdfBytes, headers: {
//     'Content-Type': 'application/pdf',
//     'Content-Disposition': 'attachment; filename="assessment.pdf"'
//   });
// }

// Future<Response> _listFilesHandler(Request request) async {
//   final directoryPath = Directory('TeamB/BusinessLayer/SavedAssessments');
//   if (!await directoryPath.exists()) {
//     return Response.ok(jsonEncode({'files': []}),
//         headers: {'Content-Type': 'application/json'});
//   }

//   final files = await directoryPath
//       .list()
//       .where((entity) => entity is File)
//       .map((entity) => entity.path)
//       .toList();

//   return Response.ok(jsonEncode({'files': files}),
//       headers: {'Content-Type': 'application/json'});
// }

// Future<Response> _getFileContentHandler(Request request) async {
//   final payload = await request.readAsString();
//   final formData = Uri(query: payload).queryParameters;
//   final fileName = formData['fileName'] ?? '';

//   if (fileName.isEmpty) {
//     return Response.badRequest(body: 'File name is required.');
//   }

//   final file = File('TeamB/BusinessLayer/SavedAssessments/$fileName');
//   if (!await file.exists()) {
//     return Response.notFound('File not found.');
//   }

//   final fileContent = await file.readAsString();

//   return Response.ok(fileContent, headers: {
//     'Content-Type': 'application/xml',
//   });
// }

// Future<String> queryAI(String query) async {
//   final postHeaders = getPostHeaders();
//   final postBody = getPostBody(query);
//   final httpPackageUrl = getPostUrl();

//   final httpPackageRespString =
//       await postMessage(httpPackageUrl, postHeaders, postBody);
//   final httpPackageResponseJson = convertHttpRespToJson(httpPackageRespString);

//   var retResponse = "";
//   for (var respChoice in httpPackageResponseJson['choices']) {
//     retResponse += respChoice['message']['content'];
//   }

//   return retResponse;
// }

// Map<String, dynamic> convertHttpRespToJson(String httpResponseString) {
//   return (json.decode(httpResponseString) as Map<String, dynamic>);
// }

// String getPostBody(String prompt) {
//   return jsonEncode({
//     'model': 'llama-3-sonar-large-32k-chat',
//     'messages': [
//       {'role': 'system', 'content': 'Be precise and concise'},
//       {'role': 'user', 'content': prompt}
//     ]
//   });
// }

// Map<String, String> getPostHeaders() {
//   return ({
//     'accept': 'application/json',
//     'content-type': 'application/json',
//     'authorization': 'Bearer $apiKey',
//   });
// }

// Uri getPostUrl() => Uri.https('api.perplexity.ai', '/chat/completions');

// Future<String> postMessage(
//     Uri url, Map<String, String> postHeaders, Object postBody) async {
//   final httpPackageResponse =
//       await http.post(url, headers: postHeaders, body: postBody);

//   if (httpPackageResponse.statusCode != 200) {
//     print('Failed to retrieve the http package!');
//     print('statusCode :  ${httpPackageResponse.statusCode}');
//     return "";
//   }

//   return httpPackageResponse.body;
// }

// Future<Uint8List> _generatePdfFromXml(String xmlContent) async {
//   final pdf = pw.Document();
//   final xmlDocument = XmlDocument.parse(xmlContent);

//   pdf.addPage(
//     pw.Page(
//       build: (pw.Context context) {
//         return pw.Center(
//           child: pw.Text(xmlDocument.toXmlString(pretty: true)),
//         );
//       },
//     ),
//   );

//   return pdf.save();
// }

// void main(List<String> args) async {
//   final ip = InternetAddress.anyIPv4;

//   final handler =
//       Pipeline().addMiddleware(logRequests()).addHandler(_router.call);

//   final port = int.parse(Platform.environment['PORT'] ?? '8000');
//   final server = await serve(handler, ip, port);
//   print('Server at http://${server.address.host}:${server.port}');
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
