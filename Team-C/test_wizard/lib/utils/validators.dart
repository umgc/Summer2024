class Validators {
  static String? checkIsEmpty(value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be blank.';
    }
    return null;
  }
}
