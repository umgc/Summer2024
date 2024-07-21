import 'dart:async';
import 'dart:io';

/**
 * If testing as a standalone component, uncomment this portion out.
void main() {
  var compiler1 = new DartCompiler().getOutput("sample.dart");
  var compiler2 = new DartCompiler().getOutput("syntaxError.dart");
  var compiler3 = new DartCompiler().getOutput("infiniteLoop.dart");
}*/

class DartCompiler {
  void getOutput(String code) async{

    print("Running");
    Timer(const Duration(seconds: 10), handleTimeout);
    var result = await Process.run('dart', [code]);

    if(result.exitCode != 0) {
      print('STDERR ${result.stderr}');
      print('EXIT CODE ${result.exitCode}');
    } else {
      stdout.write(result.stdout);
    }
  }

  void handleTimeout() {
    throw 'Time Exceeded';
  }
}