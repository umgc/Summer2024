import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:test_wizard/models/assessment.dart';
import 'package:test_wizard/models/question.dart';

class AssessmentState extends ChangeNotifier {
  final Assessment _a;

  AssessmentState({
    required int assessmentId,
    required int version,
  }) : _a = Assessment(assessmentId, version);

  int get length {
    return _a.questions.length;
  }

  UnmodifiableListView<Question> get questions {
    return UnmodifiableListView(_a.questions);
  }

  void add(Question q) {
    _a.questions.add(q);
    notifyListeners();
  }

  void update({required int id, String? newText, String? newType}) {
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

  void remove(int id) {
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
