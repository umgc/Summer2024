import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:test/test.dart';

void main() {
  final port = '8080';
  final host = 'http://127.0.0.1:$port';
  late Process p;

  setUp(() async {
    p = await Process.start(
      'dart',
      ['run', 'bin/server.dart'],
      environment: {'PORT': port},
    );
    // Wait for server to start and print to stdout.
    await p.stdout.first;
  });

  tearDown(() => p.kill());

  test('Root', () async {
    final response = await get(Uri.parse('$host/'));
    expect(response.statusCode, 200);
    expect(response.body, 'Hello, World!\n');
  });

  test('Echo', () async {
    final response = await get(Uri.parse('$host/echo/hello'));
    expect(response.statusCode, 200);
    expect(response.body, 'hello\n');
  });

  test('404', () async {
    final response = await get(Uri.parse('$host/foobar'));
    expect(response.statusCode, 404);
  });

  test('Compile', () async {
    var request = MultipartRequest('POST', Uri.parse('http://127.0.0.1:8080/compile'));
    request.files.add(await MultipartFile.fromPath('', '/home/ggaynor/dev/swen670/Summer2024/TeamB/IntelliGrade/lib/api/compiler/test/sample_math.dart'));
    request.files.add(await MultipartFile.fromPath('', '/home/ggaynor/dev/swen670/Summer2024/TeamB/IntelliGrade/lib/api/compiler/test/sample_math_simple_test.dart'));

    StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }

    expect(response.stream.bytesToString(), 'Number of tests passed: 2 out of 3');
  });
}
