class Validators {
  static String? checkIsEmpty(value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be blank.';
    }
    return null;
  }

  static String? checkCourseHasBeenSelected(String? value) {
    if (value == 'Select Course') {
      return 'Please select a course';
    }
    return null;
  }
}
