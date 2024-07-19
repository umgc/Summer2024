enum QuestionType { multipleChoice, trueFalse, shortAnswer }

class Question {
  String question;
  QuestionType type;
  var response;

  Question(this.question, this.type, this.response);
}
