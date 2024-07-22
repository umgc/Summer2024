// lib/providers/question_answer_provider.dart
import 'package:flutter/material.dart';
import 'package:test_wizard/models/question_answer_model.dart';

class QuestionAnswerProvider extends ChangeNotifier {
  List<QuestionAnswer> _questions = [
    QuestionAnswer(
      questionText: '1. What is the value of x in the equation 2x + 3 = 7?',
      answerText: 'x = 2',
    ),
    QuestionAnswer(
      questionText: '2. Solve the quadratic equation: x^2 - 4x - 5 = 0.',
      answerText: 'x = 5 or x = -1',
    ),
    QuestionAnswer(
      questionText: '3. What is the derivative of the function f(x) = 3x^2 + 2x + 1?',
      answerText: 'f\'(x) = 6x + 2',
    ),
    QuestionAnswer(
      questionText: '4. What is the integral of the function f(x) = 4x?',
      answerText: 'F(x) = 2x^2 + C',
    ),
    QuestionAnswer(
      questionText: '5. What is the slope of the line passing through the points (1,2) and (3,8)?',
      answerText: 'Slope = 3',
    ),
  ];
  List<QuestionAnswer> _deletedQuestions = [];

  List<QuestionAnswer> get questions => _questions;
  List<QuestionAnswer> get deletedQuestions => _deletedQuestions;

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
