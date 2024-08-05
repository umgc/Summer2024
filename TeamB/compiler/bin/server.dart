import 'dart:io';
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
  final files = payload.split('\n');

  //Set http boundary, file counter, and file variables
  final boundary = '--dart-http-boundary';
  int fileIncrement = 0;
  int fileCount = 0;
  List<String> testFile = [];
  List<Map<String, String>> studentFiles = [];
  String studentFileName = '';
  String fileName = '';

  // Look for number of boundaries set
  for(var k = 0; k < contents.length; k++) {
    if(files[k].contains(boundary)) {
      fileCount++;
    }
  }

  for(var i = 0; i < contents.length; i++) {
    // Checking if at boundary of response, and if both files have been read
    if(contents[i].startsWith(boundary) && fileIncrement < fileCount - 1) {
      // Looking for unit test file
      if(contents[i+2].contains('_test.dart')) { 
        //Read code-portion of payload up to the next boundary
        for(var j = i + 4; j < contents.length; j++) {
          // If boundary was reached, set j to list length to terminate loop
          if(contents[j].startsWith(boundary)) {
            j = contents.length;
            fileIncrement++;
          } else {
            testFile.add(contents[j]);
          }
        }
      // If unit test file was not found, we are at submission file
      } else {
        //Get name of student-code submitted file
        fileName = contents[i+2].split('"')[1]; 
        studentFileName = contents[i+2].split('"')[3]; 
        List<String> submissionFile = [];
        //Read code-portion of payload up to the next boundary
        for(var j = i + 4; j < contents.length; j++) {
          // If boundary was reached, set j to list length to terminate loop
          if(contents[j].startsWith(boundary)) {
            j = contents.length;
            fileIncrement++;
            var nameFilePair = {
              studentFileName: submissionFile.join('\n')
            };
            studentFiles.add(nameFilePair);
          } else {
            submissionFile.add(contents[j]);
          }
        }
      }
    }
  }

  // Run compiler and return results
  final compiler = new DartCompiler();
  final output = await compiler.getOutput(testFile.join('\n'), studentFiles, fileName);

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
