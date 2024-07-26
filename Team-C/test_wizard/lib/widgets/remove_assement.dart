import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:test_wizard/models/assessment_set.dart';
import 'package:test_wizard/models/saved_assessments.dart';

class AssessmentProvider extends ChangeNotifier {
  /// Internal, private state of assessments in local storage.
  final SavedAssessments _savedAssessments = SavedAssessments();

  /// An unmodifiable view of the assessments.
  UnmodifiableListView<AssessmentSet> get assessmentSets =>
      UnmodifiableListView(_savedAssessments.assessmentSets);

  AssessmentProvider();

  /// Adds [assessmentSet] to the list of assessments in local storage. This and [removeAll] are the only ways to modify the
  /// list of assessments from the outside.
  void add(AssessmentSet assessmentSet) {
    _savedAssessments.assessmentSets.add(assessmentSet);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  /// Removes an assessment by its name.
  void removeAssessment(String assessmentName) {
    _savedAssessments.assessmentSets.removeWhere((assessmentSet) => assessmentSet.assessmentName == assessmentName);
    notifyListeners();
  }

  /// Removes all assessments from the list.
  void removeAll() {
    _savedAssessments.assessmentSets.clear();
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
