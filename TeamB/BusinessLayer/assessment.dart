import 'question.dart';

class Assessment {
  List<Question> questions = [];

  void addQuestion(Question question) {
    questions.add(question);
  }

  List<Question> getQuestions() {
    return questions;
  }
}

import 'question.dart';
import 'package:xml/xml.dart';
import 'dart:convert';

class Assessment {
  List<Question> questions = [];

  void addQuestion(Question question) {
    questions.add(question);
  }

  List<Question> getQuestions() {
    return questions;
  }

  static Assessment fromAIResponse(String aiResponse) {
    final questions = (json.decode(aiResponse) as List)
        .map((q) => Question(
            q['question'], QuestionType.values[q['type']], q['response']))
        .toList();
    final assessment = Assessment();
    questions.forEach(assessment.addQuestion);
    return assessment;
  }
}

class AssessmentWithAnswers extends Assessment {
  List<String> answers = [];

  void addAnswer(String answer) {
    answers.add(answer);
  }

  List<String> getAnswers() {
    return answers;
  }

  static AssessmentWithAnswers fromXML(String xmlString) {
    final document = XmlDocument.parse(xmlString);
    final assessment = AssessmentWithAnswers();

    document.findAllElements('question').forEach((element) {
      final questionText = element.findElements('text').single.text;
      final typeText = element.findElements('type').single.text;
      final response = element.findElements('response').single.text;
      final answer = element.findElements('answer').single.text;

      final type = _parseQuestionType(typeText);

      final question = Question(questionText, type, response);
      assessment.addQuestion(question);
      assessment.addAnswer(answer);
    });

    return assessment;
  }

  static QuestionType _parseQuestionType(String type) {
    switch (type.toLowerCase()) {
      case 'multiplechoice':
        return QuestionType.multipleChoice;
      case 'truefalse':
        return QuestionType.trueFalse;
      case 'shortanswer':
        return QuestionType.shortAnswer;
      default:
        throw ArgumentError('Unknown question type: $type');
    }
  }
}
