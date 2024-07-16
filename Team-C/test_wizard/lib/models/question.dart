class Question {

  //unique identifier for the question
  int questionId = 0;

  //text describing the question
  String questionText = "";

  //Type of question
  String questionType = "";

  //Answer to the question
  String answer = "";

  String rubric = "";

  int points = 0;

  //Answer Options, answer is included in this list.
  List<String> answerOptions = [];

  Question();
}