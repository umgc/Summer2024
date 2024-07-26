import 'package:intelligrade/api/compiler_module/compiler_api_service.dart';

// Unit test for compiler service.
void main() async {
  final studentFilePath = 'assets/test_files/sample_math.dart';
  final testFilePath = 'assets/test_files/sample_math_simple_test.dart';
  print(await CompilerApiService.compileAndGrade(studentFilePath: studentFilePath, testFilePath: testFilePath));
}