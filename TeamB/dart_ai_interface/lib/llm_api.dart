import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:xml/xml.dart';

///
/// The core class that takes user-entered parameters and generates an LLM prompt.
/// This class is used to both generate assessments and suggest grades.
///
class LlmApi {
  final String apiKey;

  LlmApi(this.apiKey);

  Router get router {
    final _router = Router();

    _router.get('/', _rootHandler);
    _router.get('/<message>', _echoHandler);
    _router.post('/api/', _apiHandler);

    return _router;
  }

  Future<Response> _apiHandler(Request request) async {
    final uri = Uri(query: await request.readAsString());
    final formData = uri.queryParameters;
    print(formData);
    // print("formData['QueryPrompt']: ${formData['QueryPrompt']}");

    final queryPrompt = formData['QueryPrompt'];
    var resp = "";

    // use the following test query so Perplexity doesn't charge
    // 'How many stars are there in our galaxy?'
    if (queryPrompt!.isNotEmpty) {
      resp = await queryAI(queryPrompt);
    }

    // print("The LLM's response: $resp");
    return Response.ok(
      // '''You sent:
      // $formData

      // AI Response:
      // $resp
      // ''',
      // headers: {'Content-type': 'text/plain'},
      '''
      $resp
      ''',
      headers: {'Content-type': 'application/json'},
    );
  }

  Response _echoHandler(Request request) {
    final message = request.params['message'];
    return Response.ok('$message\n');
  }

  Response _rootHandler(Request req) {
    return Response.ok(
        "IntelliGrade's AI Interface Server has started Successfully !\n");
  }

  Map<String, dynamic> convertHttpRespToJson(String httpResponseString) {
    return (json.decode(httpResponseString) as Map<String, dynamic>);
  }

  ///
  ///
  ///
  String getPostBody(String prompt) {
    return jsonEncode({
      // 'model': 'llama-3-sonar-large-32k-online',
      'model': 'llama-3-sonar-large-32k-chat',
      'messages': [
        {'role': 'system', 'content': 'Be precise and concise'},
        {'role': 'user', 'content': prompt}
      ]
    });
  }

  ///
  Map<String, String> getPostHeaders() {
    return ({
      'accept': 'application/json',
      'content-type': 'application/json',
      'authorization': 'Bearer $apiKey',
    });
  }

  ///
  Uri getPostUrl() => Uri.https('api.perplexity.ai', '/chat/completions');

  /// Changing this to parse the XML instead
  Object parseQueryResponse(String resp) {
    // ignore: prefer_adjacent_string_concatenation
    String regExpStr =
        r'(Here is the response in JSON format:((\s)*(`){3}(\s)*)(?<jsonresp>(\{|\s|.)*)((\s)*(`){3}))';

    RegExp exp = RegExp(regExpStr);
    Iterable<RegExpMatch> matches = exp.allMatches(resp);
    var parsedResp;

    for (final m in matches) {
      String match = m[0]!;
      print("Number of matches: ${m.groupCount}");
      // print("Named capturing group : ${m.namedGroup('jsonresp')}");
      print("This is a match : $match");

      // ignore: prefer_adjacent_string_concatenation
      // var tempStr =
      //     '{\n"assignments": [\n\n{"title": "Adding Integers and Floats", "task": "Write a Java application that takes two numbers as input, one integer and one float, andreturns their sum.","requirements": ["The integer should be a 32-bit signed integer (int in Java).","The float should be a 32-bit IEEE 754 floating-point number (float in Java).","The application should handle overflow and underflow for integer addition.","The application should handle NaN (Not a Number) and Infinity for float addition."],"rubric": {"correctness": 40,"codeQuality": 30,"errorHandling": 30}}]},';
      Map<String, dynamic> parsedResp =
          jsonDecode(m.namedGroup('jsonresp')!.replaceAll('NaN', '"NaN"'));

      // Map<String, dynamic> parsedResp =
      //     jsonDecode(m.namedGroup('jsonresp')!.replaceAll('NaN', '"NaN"'));
      print("parsedResp : $parsedResp");
    }

    print("In parseQueryResponse - matches: $matches");
    return {};
  }

  ///
  Future<String> postMessage(
      Uri url, Map<String, String> postHeaders, Object postBody) async {
    final httpPackageResponse =
        await http.post(url, headers: postHeaders, body: postBody);

    if (httpPackageResponse.statusCode != 200) {
      print('Failed to retrieve the http package!');
      print('statusCode :  ${httpPackageResponse.statusCode}');
      return "";
    }

    // print(httpPackageResponse.body);

    return httpPackageResponse.body;
  }

  Future<String> queryAI(String query) async {
    // const prompt1 = 'How many stars are there in our galaxy?';
    final postHeaders = getPostHeaders();
    final postBody = getPostBody(query);
    final httpPackageUrl = getPostUrl();
    // print("In queryAI !!");
    // print('The url : $httpPackageUrl');

    final httpPackageRespString =
        await postMessage(httpPackageUrl, postHeaders, postBody);

    final httpPackageResponseJson =
        convertHttpRespToJson(httpPackageRespString);

    print("httpPackageResponseJson : $httpPackageRespString");
    var retResponse = "";
    for (var respChoice in httpPackageResponseJson['choices']) {
      retResponse += respChoice['message']['content'];
    }

    final parsedResp = parseQueryResponse(retResponse);

    print("After parseQueryResponse - retResponse: $retResponse");

    return retResponse;
  }
}
