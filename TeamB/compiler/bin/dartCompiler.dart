import 'dart:async';
import 'dart:io';

//If testing as a standalone component, uncomment this portion out.
/*void main() {
  var compiler1 = new DartCompiler().getOutput("sample.dart");
  var compiler2 = new DartCompiler().getOutput("syntaxError.dart");
  var compiler3 = new DartCompiler().getOutput("infiniteLoop.dart");
}*/

class DartCompiler {
  Future<String> getOutput(String testCode, studentCode, studentFileName) async {

    //Timer(const Duration(seconds: 10), handleTimeout);
    final testFileName = '/app/bin/unit_test.dart';
    var testFile = await File(testFileName).writeAsString(testCode);

    studentFileName = '/app/bin/$studentFileName';
    var studentFile = await File(studentFileName).writeAsString(studentCode);
    
    var testResult = Process.runSync('dart', [testFileName]);

    if(testResult.exitCode != 0) {
      return testResult.stderr + '\n';
    } else {
      return testResult.stdout;
    }
  }

  void handleTimeout() {
    throw 'Time Exceeded';
  }
}