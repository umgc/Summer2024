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
