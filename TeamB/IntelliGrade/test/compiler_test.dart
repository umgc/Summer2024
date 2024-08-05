import 'dart:typed_data';
import 'dart:io';

import 'package:intelligrade/api/compiler_module/compiler_api_service.dart';
import 'package:intelligrade/controller/model/beans.dart';

// Unit test for compiler service.
void main() async {

  final List<String> filePaths = [
    'assets/test_files/ebennett_sample_math.dart',
    'assets/test_files/ggaynor_sample_math.dart',
    'assets/test_files/tzhu_sample_math.dart',
    'assets/test_files/sample_math_simple_test.dart'
  ];

  final List<FileNameAndBytes> files = [];

  for (String filePath in filePaths) {
    files.add(FileNameAndBytes(filePath.split('/').last, await File(filePath).readAsBytes()));
  }

  String response = await CompilerApiService.compileAndGrade(files);
  print(response);


  // final studentFilePath = 'assets/test_files/sample_math.dart';
  // final studentFileName = studentFilePath.split('/').last;
  // final studentFilePath2 = 'assets/test_files/ebennett_sample_math.dart';
  // final studentFilePath3 = 'assets/test_files/ggaynor_sample_math.dart';
  // final studentFilePath4 = 'assets/test_files/tzhu_sample_math.dart';
  // final gradingFilePath = 'assets/test_files/sample_math_simple_test.dart';
  // final gradingFileName = gradingFilePath.split('/').last;
  // // Uint8List studentFileBytes = await File(studentFilePath).readAsBytes();
  // Uint8List studentFileBytes2 = await File(studentFilePath2).readAsBytes();
  // Uint8List studentFileBytes3 = await File(studentFilePath3).readAsBytes();
  // Uint8List studentFileBytes4 = await File(studentFilePath4).readAsBytes();
  // Uint8List gradingFileBytes = await File(gradingFilePath).readAsBytes();
  // print(await CompilerApiService.compileAndGrade(
  //     studentFileName: 'sample_math.dart',
  //     studentFileBytesList: [studentFileBytes2, studentFileBytes3, studentFileBytes4],
  //     gradingFileName: gradingFileName,
  //     gradingFileBytes: gradingFileBytes
  // ));
}