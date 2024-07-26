import 'package:http/http.dart';

void main() async {
  var request = MultipartRequest('POST', Uri.parse('http://127.0.0.1:8080/compile'));
  request.files.add(await MultipartFile.fromPath('sample_math.dart', '/home/ggaynor/dev/swen670/Summer2024/TeamB/IntelliGrade/lib/api/compiler/test/sample_math.dart'));
  request.files.add(await MultipartFile.fromPath('sample_math_simple_test.dart', '/home/ggaynor/dev/swen670/Summer2024/TeamB/IntelliGrade/lib/api/compiler/test/sample_math_simple_test.dart'));

  StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
  }
}