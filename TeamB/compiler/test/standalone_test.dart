import 'package:http/http.dart';

void main() async {
  var request = MultipartRequest('POST', Uri.parse('http://3.143.209.60:8080/compile'));
  request.files.add(await MultipartFile.fromPath('sample_math.dart', '/home/ggaynor/dev/swen670/Summer2024/TeamB/compiler/test/compiler_test_files/with_unit_test/ggaynor_sample_math.dart'));
  request.files.add(await MultipartFile.fromPath('sample_math.dart', '/home/ggaynor/dev/swen670/Summer2024/TeamB/compiler/test/compiler_test_files/with_unit_test/tzhu_sample_math.dart'));
  request.files.add(await MultipartFile.fromPath('sample_math.dart', '/home/ggaynor/dev/swen670/Summer2024/TeamB/compiler/test/compiler_test_files/with_unit_test/ebennett_sample_math.dart'));
  request.files.add(await MultipartFile.fromPath('sample_math_simple_test.dart', '/home/ggaynor/dev/swen670/Summer2024/TeamB/compiler/test/compiler_test_files/with_unit_test/sample_math_simple_test.dart'));

  StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
  }
}