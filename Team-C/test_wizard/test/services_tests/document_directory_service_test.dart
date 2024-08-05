import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_wizard/services/document_directory_service.dart';

void main() {
  LiveTestWidgetsFlutterBinding.ensureInitialized();
  group('document_directory_service', () {
    test('constructor correctly instantiates class', () {
      final dds = DocumentDirectoryService('assessments');
      expect(dds.model, 'assessments');
    });

    testWidgets('correctly reads json from a file', (tester) async {
      // This code intercepts the call to the getApplicationDocumentsDirectory
      // and instead responds with our own
      const channel = MethodChannel(
        'plugins.flutter.io/path_provider',
      );
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        (methodCall) async {
          if (methodCall.method == 'getApplicationDocumentsDirectory') {
            return "./";
          }
          return '';
        },
      );
      // this sets up the file in the directory
      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path;
      File file = File('$path/assessments.txt');
      // set up the file with valid json
      String validJson = '{"hello": "world"}';
      await file.writeAsString(validJson);

      // see if dds can correctly find and read it
      final dds = DocumentDirectoryService('assessments');
      Map<String, dynamic> json = await dds.readJsonFromFile();
      expect(json, {"hello": "world"});
    });
    testWidgets('returns blank map on error', (tester) async {
      // This code intercepts the call to the getApplicationDocumentsDirectory
      // and instead responds with our own
      const channel = MethodChannel(
        'plugins.flutter.io/path_provider',
      );
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        (methodCall) async {
          if (methodCall.method == 'getApplicationDocumentsDirectory') {
            return "./";
          }
          return '';
        },
      );
      // this sets up the file in the directory
      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path;
      File file = File('$path/assessments.txt');
      // set up the file with valid json
      String invalid = '{hello world}';
      await file.writeAsString(invalid);

      // see if dds can correctly find and read it
      final dds = DocumentDirectoryService('assessments');
      Map<String, dynamic> json = await dds.readJsonFromFile();
      expect(json, {});
    });
    testWidgets('correctly writes json to file', (tester) async {
      // This code intercepts the call to the getApplicationDocumentsDirectory
      // and instead responds with our own
      const channel = MethodChannel(
        'plugins.flutter.io/path_provider',
      );
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        (methodCall) async {
          if (methodCall.method == 'getApplicationDocumentsDirectory') {
            return "./";
          }
          return '';
        },
      );
      // this sets up the file in the directory
      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path;
      File file = File('$path/assessments.txt');
      await file.writeAsString('');
      // set up the file with valid json
      String validJson = '{"hello":"world"}';
      Map<String, dynamic> json = {"hello": "world"};

      // see if dds can correctly find and read it
      final dds = DocumentDirectoryService('assessments');
      await dds.writeJsonToFile(json);
      String result = await file.readAsString();
      expect(result, validJson);
    });
  });
}
