import 'dart:async';
import 'dart:io';


//If testing as a standalone component, uncomment this portion out.
/*void main() {
  var compiler1 = new DartCompiler().getOutput("sample.dart");
  var compiler2 = new DartCompiler().getOutput("syntaxError.dart");
  var compiler3 = new DartCompiler().getOutput("infiniteLoop.dart");
}*/

class DartCompiler {
  Future<String> getOutput(String code) async {

    //Timer(const Duration(seconds: 10), handleTimeout);
    final filename = '/app/bin/file.dart';
    var file = await File(filename).writeAsString(code);
    var result = Process.runSync('dart', [filename]);

    if(result.exitCode != 0) {
      return result.stderr + '\n';
    } else {
      return result.stdout;
    }
  }

  void handleTimeout() {
    throw 'Time Exceeded';
  }
}