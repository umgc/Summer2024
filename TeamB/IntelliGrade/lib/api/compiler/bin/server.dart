import 'dart:io';
import 'dart:convert';
import 'dartCompiler.dart';
import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

// Configure routes.
final _router = Router()
  ..get('/', _rootHandler)
  ..get('/echo/<message>', _echoHandler)
  ..post('/compile', _compilerHandler);

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

Future<Response> _compilerHandler(Request req) async {
  // Read payload from request and split contents
  final payload = await req.readAsString();
  final contents = payload.split('\n');
  final code = contents.sublist(4, contents.length - 2).join('\n');
  
  // Run compiler and return results
  final compiler = new DartCompiler();
  final output = await compiler.getOutput(code);

  return Response.ok(output);
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4; //Currently using localhost, will change later

  // Configure a pipeline that logs requests.
  final handler =
      Pipeline().addMiddleware(logRequests()).addHandler(_router.call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080'); //This port will change later
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
