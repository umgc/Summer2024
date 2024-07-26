import 'dart:collection';
import 'package:flutter/widgets.dart';
import 'package:test_wizard/models/assessment_set.dart';
import 'package:test_wizard/models/saved_assessments.dart';

class AssessmentProvider extends ChangeNotifier {
  final SavedAssessments _savedAssessments = SavedAssessments();

  UnmodifiableListView<AssessmentSet> get assessmentSets =>
      UnmodifiableListView(_savedAssessments.assessmentSets);

  AssessmentProvider();

  void add(AssessmentSet assessmentSet) {
    _savedAssessments.assessmentSets.add(assessmentSet);
    notifyListeners();
  }

  void removeAssessment(String assessmentName) {
    _savedAssessments.assessmentSets.removeWhere((assessmentSet) => assessmentSet.assessmentName == assessmentName);
    notifyListeners();
  }

  void removeAll() {
    _savedAssessments.assessmentSets.clear();
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
