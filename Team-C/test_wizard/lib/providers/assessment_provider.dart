import 'package:flutter/widgets.dart';
import 'package:test_wizard/models/assessment.dart';
import 'package:test_wizard/models/assessment_set.dart';
import 'package:test_wizard/models/question.dart';
import 'package:test_wizard/models/saved_assessments.dart';

class AssessmentProvider extends ChangeNotifier {
  /// Internal, private state of assessments in local storage.
  final SavedAssessments _savedAssessments = SavedAssessments();
  Assessment _a = Assessment(0, 0, true);

  /// An unmodifiable view of the assessments.
  List<AssessmentSet> get assessmentSets =>
      _savedAssessments.assessmentSets;

    /// An unmodifiable view of the assessments.
  List<Assessment> getAssessmentsFromAssessmentSets(int assessmentSetIndex){
    return _savedAssessments.assessmentSets[assessmentSetIndex].assessments;
  }

      /// An unmodifiable view of the assessments.
  Assessment getAssessmentFromAssessmentSet(int assessmentSetIndex, int assessmentIndex){
    return _savedAssessments.assessmentSets[assessmentSetIndex].assessments[assessmentIndex];
  }

  List<Question> get questions => _a.questions;

  AssessmentProvider();

  //adds assessment to assessmentSet
  void addAssessmentToAssessmentSet(int savedAssessmentsIndex){
    _savedAssessments.assessmentSets[savedAssessmentsIndex].assessments.add(_a);
    notifyListeners();
  }

  void createAssessmentVersion(int assessmentId, int version, bool isExampleAssessment){
    _a = Assessment(assessmentId, version, isExampleAssessment);
    notifyListeners();
  }

  /// Adds [assessment] to list of assessments in local storage. This and [removeAll] are the only ways to modify the
  /// list of assessments from the outside.
  void addAssessmentSet(AssessmentSet assessmentSet) {
    _savedAssessments.assessmentSets.add(assessmentSet);
    // This call tells the widgets that are listening to this model to rebuild.
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

  int get length {
    return _a.questions.length;
  }

  void addQuestion(Question q) {
    _a.questions.add(q);
    notifyListeners();
  }

  void updateQuestion({required int id, String? newText, String? newType}) {
    _a.questions = _a.questions.map(
      (curr) {
        if (curr.questionId == id) {
          curr.questionText = newText ?? curr.questionText;
          curr.questionType = newType ?? curr.questionType;
        }
        return curr;
      },
    ).toList();
    notifyListeners();
  }

  void removeQuestion(int id) {
    int foundIndex = _a.questions.indexWhere((q) => q.questionId == id);
    // splice out the found question
    _a.questions = [
      ..._a.questions.getRange(0, foundIndex),
      ..._a.questions.getRange(foundIndex + 1, _a.questions.length)
    ];
    notifyListeners();
  }

  Map<String, int> getQuestionTypeCount() {
    var questionCount = {
      "Multiple Choice": 0,
      "Short Answer": 0,
      "Essay": 0,
    };

    for (Question question in _a.questions) {
      questionCount[question.questionType] =
          questionCount[question.questionType]! + 1;
    }

    return questionCount;
  }
}
