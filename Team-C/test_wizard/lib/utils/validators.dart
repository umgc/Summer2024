class Validators {
  static String? checkIsEmpty(value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be blank.';
    }
    return null;
  }

  static String? checkOptionHasBeenSelected(String? value) {
    if (value!.startsWith('Select')) {
      return 'Please select an option.';
    }
    return null;
  }

  static String? checkIsOneOrTwoDigits(String? value) {
    if (value?.length == 1 || value?.length == 2) {
      return null;
    }
    return 'Please enter one or two digits.';
  }
}
