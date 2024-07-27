import 'dart:typed_data';
import 'dart:io';

import 'package:intelligrade/api/compiler_module/compiler_api_service.dart';

// Unit test for compiler service.
void main() async {
  final studentFilePath = 'assets/test_files/sample_math.dart';
  final studentFileName = studentFilePath.split('/').last;
  final gradingFilePath = 'assets/test_files/sample_math_simple_test.dart';
  final gradingFileName = gradingFilePath.split('/').last;
  Uint8List studentFileBytes = await File(studentFilePath).readAsBytes();
  Uint8List gradingFileBytes = await File(gradingFilePath).readAsBytes();
  print(await CompilerApiService.compileAndGrade(
      studentFileName: studentFileName,
      studentFileBytes: studentFileBytes,
      gradingFileName: gradingFileName,
      gradingFileBytes: gradingFileBytes
  ));
}