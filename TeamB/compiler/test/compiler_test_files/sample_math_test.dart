import "../sample_math.dart";
import 'package:test/test.dart';

void main() {

  int totalTests = 0;
  int passedTests = 0;
  group('Some math, add, subtract, multiply', () {


    test('Add should add', () {
      SampleMath mather = new SampleMath();
      int expectedValue = 5;
      int result = mather.add(2, 3);

      if(expectedValue == result) {
        passedTests++;
      }
      totalTests++;
      expect(expectedValue, result);
    });

    test('Subtract should subtract', () {
      SampleMath mather = new SampleMath();
      int expectedValue = 1;
      int result = mather.subtract(3, 2);

      if(expectedValue == result) {
        passedTests++;
        //print(passedTests);
      }
      totalTests++;
      expect(expectedValue, result);
    });

    test('Multiply should multiply', () {
      SampleMath mather = new SampleMath();
      int expectedValue = 6;
      int result = mather.multiply(2, 3);

      if(expectedValue == result) {
        passedTests++;
        
      }
      totalTests++;
      expect(expectedValue, result);
    });
  });

  tearDownAll(() {
    print('Number of tests passed: $passedTests out of $totalTests');
  });
}