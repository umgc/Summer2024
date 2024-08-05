import 'dart:async';
import 'dart:io';

//If testing as a standalone component, uncomment this portion out.
/*void main() {
  var compiler1 = new DartCompiler().getOutput("sample.dart");
  var compiler2 = new DartCompiler().getOutput("syntaxError.dart");
  var compiler3 = new DartCompiler().getOutput("infiniteLoop.dart");
}*/

class DartCompiler {
  Future<String> getOutput(String testCode, List<Map<String, String>> studentFiles, String fileName) async {

    var results = '';
    final testFileName = '/app/bin/unit_test.dart';
    var testFile = await File(testFileName).writeAsString(testCode);

    fileName = '/app/bin/$fileName';

    for(int i = 0; i < studentFiles.length; i++) {
      var studentFile = await File(fileName).writeAsString(studentFiles[i].values.first, mode: FileMode.writeOnly);
      var testResults = await Process.run('dart', [testFileName]);

      if(testResults.exitCode != 0) {
        results = results + studentFiles[i].keys.first.split('_')[0] + ': ' + testResults.stderr + '\n';
      } else {
        results = results + studentFiles[i].keys.first.split('_')[0] + ': ' + testResults.stdout + '\n';
      }
    }

    return results;
  }
}