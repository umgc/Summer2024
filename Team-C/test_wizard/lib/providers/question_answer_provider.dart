// lib/providers/question_answer_provider.dart
import 'package:flutter/material.dart';
import 'package:test_wizard/models/question_answer_model.dart';

class QuestionAnswerProvider extends ChangeNotifier {
  final List<QuestionAnswer> _questions = [];  // Add final
  final List<QuestionAnswer> _deletedQuestions = [];  // Add final

  List<QuestionAnswer> get questions => _questions;
  List<QuestionAnswer> get deletedQuestions => _deletedQuestions;

  // Add some sample data
  QuestionAnswerProvider() {
    _questions.addAll([
      QuestionAnswer(questionText: 'What is the slope of the line that passes through the points (2, 3) and (4, 7)?', answerText: 'Slope = 2'),
      QuestionAnswer(questionText: 'Solve for x: 2x + 3 = 7', answerText: 'x = 2'),
      QuestionAnswer(questionText: 'What is the derivative of f(x) = x^2?', answerText: 'f\'(x) = 2x'),
      QuestionAnswer(questionText: 'Integrate the function f(x) = 3x^2.', answerText: 'F(x) = x^3 + C'),
      QuestionAnswer(questionText: 'What is the value of pi to 2 decimal places?', answerText: '3.14'),
    ]);
  }

  void addQuestion(QuestionAnswer question) {
    _questions.add(question);
    notifyListeners();
  }

  void updateQuestion(String oldQuestionText, String newQuestionText) {
    final index = _questions.indexWhere((qa) => qa.questionText == oldQuestionText);
    if (index != -1) {
      _questions[index] = QuestionAnswer(questionText: newQuestionText, answerText: _questions[index].answerText);
      notifyListeners();
    }
  }

  void regenerateQuestion(String oldQuestionText, String newQuestionText) {
    updateQuestion(oldQuestionText, newQuestionText);
  }

  void updateAnswer(String questionText, String newAnswerText) {
    final index = _questions.indexWhere((qa) => qa.questionText == questionText);
    if (index != -1) {
      _questions[index] = QuestionAnswer(questionText: _questions[index].questionText, answerText: newAnswerText);
      notifyListeners();
    }
  }

  void deleteQuestion(String questionText) {
    final index = _questions.indexWhere((qa) => qa.questionText == questionText);
    if (index != -1) {
      _deletedQuestions.add(_questions.removeAt(index));
      notifyListeners();
    }
  }

  void restoreQuestion(QuestionAnswer question) {
    _deletedQuestions.remove(question);
    _questions.add(question);
    notifyListeners();
  }
}
