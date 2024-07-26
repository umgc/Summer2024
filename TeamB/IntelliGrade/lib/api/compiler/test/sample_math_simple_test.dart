import "sample_math.dart";

void main() {

  int totalTest = 0;
  int passedTests = 0;

  totalTest++;
  if(test1()) {
    passedTests++;
  }
  totalTest++;
  if(test2()) {
    passedTests++;
  }

  totalTest++;
  if(test3()) {
    passedTests++;
  }
  
  print('Number of tests passed: $passedTests out of $totalTest');
}

bool test1() {
  SampleMath mather = SampleMath();
  int expectedValue = 5;
  int result = mather.add(2, 3);

  return expectedValue == result;
}

bool test2() {
  SampleMath mather = SampleMath();
  int expectedValue = 1;
  int result = mather.subtract(4, 3);

  return expectedValue == result;
}

bool test3() {
  SampleMath mather = SampleMath();
  int expectedValue = 6;
  int result = mather.multiply(2, 3);

  return expectedValue == result;
}