class TempModel {
  static Future<List<String>> fetchDropdownOptions(String optionName) async {
    switch (optionName) {
      case 'Course':
        return ['Select Course', 'Course 1', 'Course 2'];
      case 'Assessment Type':
        return [
          'Select Assessment Type',
          'Short Answer',
          'Multiple Choice',
          'Essay'
        ];
      case 'Graded On':
        return [
          'Select Graded On',
          'Standards Based Grading',
          'Points Based Grading'
        ];
      default:
        return [];
    }
  }
}
