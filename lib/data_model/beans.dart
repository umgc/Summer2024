
// A Moodle quiz containing a list of questions.
class Quiz {
  String name;         // quiz name - required.
  String? description; // quiz description - optional.
  final List<Question> questionList = <Question>[]; // list of questions on the quiz.

  // Constructor that takes in simple fields.
  Quiz(this.name, this.description);

  @override
  String toString() {
    final sb = StringBuffer();
    sb.write('Quiz Name: $name\n');
    sb.write('Quiz Description: $description\n\n');
    for (var i = 1; i <= questionList.length; i++) {
      sb.write('Q$i: ');
      sb.write(questionList[i - 1].toString());
      sb.write('\n\n');
    }
    return sb.toString();
  }
}

// Abstract class that represents a single question.
abstract class Question {
  late String name;             // question name - required.
  late String questionText;     // question text - required.
  String? generalFeedback; // question feedback - optional.

  // Constructor (do not use this)
  Question(this.name, this.questionText);
}

// Multiple choice question.
class MultiChoiceQuestion extends Question {
  List<QuestionChoice> choiceList = <QuestionChoice>[]; // list of multiple choice options

  // Constructor
  MultiChoiceQuestion(super.name, super.questionText, this.choiceList);

  @override
  String toString() {
    final sb = StringBuffer();
    sb.write('$name\n$questionText');
    int charcode = 'A'.codeUnitAt(0);
    for (QuestionChoice choice in choiceList) {
      String letter = String.fromCharCode(charcode);
      String choiceStr = choice.toString();
      sb.write('\n  $letter. $choiceStr');
      charcode++;
    }
    return sb.toString();
  }
}

// True/false question.
class TrueFalseQuestion extends Question {
  bool answer;  // the correct True/False answer.

  // Constructor
  TrueFalseQuestion(super.name, super.questionText, this.answer);

  @override
  String toString() {
    final sb = StringBuffer();
    sb.write('$name\n$questionText\n  True\n  False\n  Correct response: $answer');
    return sb.toString();
  }
}

// Short answer question.
class ShortAnswerQuestion extends Question {
  List<String> correctAnswers = <String>[]; // list of acceptable short answers

  // Constructor
  ShortAnswerQuestion(super.name, super.questionText, this.correctAnswers);

  @override
  String toString() {
    final sb = StringBuffer();
    sb.write('$name\n$questionText\n');
    String answers = correctAnswers.join(', ');
    sb.write('  Accepted answers: $answers');
    return sb.toString();
  }
}

// Essay question.
class EssayQuestion extends Question {
  // No additional fields.
  EssayQuestion(super.name, super.questionText);

  @override
  String toString() {
    return '$name\n$questionText';
  }
}

// Coding question.
class CodingQuestion extends Question {
  // No additional fields.
  CodingQuestion(super.name, super.questionText);

  @override
  String toString() {
    return '$name\n$questionText';
  }
}

// A choice for multiple choice questions.
class QuestionChoice {
  String choiceText;  // Multiple choice text - required
  bool isCorrect;     // If choice is correct - required

  // Constructor
  QuestionChoice(this.choiceText, this.isCorrect);

  @override
  String toString() {
    final sb = StringBuffer();
    sb.write('$choiceText');
    if (isCorrect) {
      sb.write(' <= correct');
    }
    return sb.toString();
  }
}
