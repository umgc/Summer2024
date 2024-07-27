import 'dart:typed_data';
import 'package:http/http.dart' as http;

// Static class to access compiler service.
class CompilerApiService {
  static const port = '8080';
  static const baseUrl = 'http://3.143.209.60:$port';
  static const compileUrl = '$baseUrl/compile';

  // Submits student file and instructor test file to the compiler. The test
  // file is run and output is returned.
  static Future<String> compileAndGrade({
    required Uint8List studentFileBytes,
    required String studentFileName,
    required Uint8List gradingFileBytes,
    required String gradingFileName
  }) async {
    final request = http.MultipartRequest('POST', Uri.parse(compileUrl));
    request.files.add(http.MultipartFile.fromBytes(studentFileName, studentFileBytes));
    request.files.add(http.MultipartFile.fromBytes(gradingFileName, gradingFileBytes));
    // request.files.add(await http.MultipartFile.fromPath(studentFilePath.split('/').last, studentFilePath));
    // request.files.add(await http.MultipartFile.fromPath(testFilePath.split('/').last, testFilePath));
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
    return response.body;
  }
}