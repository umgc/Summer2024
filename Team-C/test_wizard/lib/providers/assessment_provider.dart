import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:test_wizard/models/assessment.dart';
import 'package:test_wizard/models/saved_assessments.dart';

class AssessmentProvider extends ChangeNotifier {
  /// Internal, private state of assessments in local storage.
  final SavedAssessments _savedAssessments = SavedAssessments();

  /// An unmodifiable view of the assessments.
  UnmodifiableListView<Assessment> get assessments =>
      UnmodifiableListView(_savedAssessments.assessments);

  AssessmentProvider();

  /// Adds [assessment] to list of assessments in local storage. This and [removeAll] are the only ways to modify the
  /// list of assessments from the outside.
  void add(Assessment assessment) {
    _savedAssessments.assessments.add(assessment);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes all assessments from the list.
  void removeAll() {
    _savedAssessments.assessments.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  Future<void> saveAssessmentsToFile() async {
    await _savedAssessments.saveAssessmentsToFile();
  }

  Future<void> loadAssessmentsFromFile() async {
    await _savedAssessments.loadAssessmentsFromFile();
    notifyListeners();
  }
}
