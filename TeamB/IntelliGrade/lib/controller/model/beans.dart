import 'package:xml/xml.dart';

// Tags and attributes used in Moodle XML. Useful for preventing typos.
class XmlConsts {
  static const quiz = 'quiz';
  static const question = 'question';
  static const name = 'name';
  static const type = 'type';
  static const text = 'text';
  static const questiontext = 'questiontext';
  static const format = 'format';
  static const answer = 'answer';
  static const fraction = 'fraction';
  static const feedback = 'feedback';

  // not tags but useful constants
  static const multichoice = 'multichoice';
  static const truefalse = 'truefalse';
  static const shortanswer = 'shortanswer';
  static const essay = 'essay';
  static const html = 'html';
}

// A Moodle quiz containing a list of questions.
class Quiz {
  String? name;         // quiz name - optional.
  String? description; // quiz description - optional.
  List<Question> questionList = <Question>[]; // list of questions on the quiz.

  // Constructor with all optional params.
  Quiz({this.name, this.description, List<Question>? questionList})
    : questionList = questionList ?? [];

  // XML factory constructor using XML string
  factory Quiz.fromXmlString(String xmlStr) {
    Quiz quiz = Quiz();
    final document = XmlDocument.parse(xmlStr);
    for (XmlElement questionElement in document.findAllElements(XmlConsts.question).toList()) {
      quiz.questionList.add(Question.fromXml(questionElement));
    }
    return quiz;
  }

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
class Question {
  String name;             // question name - required.
  String type;             // question type (multichoice, truefalse, shortanswer, essay) - required.
  String questionText;     // question text - required.
  List<Answer> answerList = <Answer>[]; // list of answers. Not needed for essay.

  // Simple constructor. The answerList param is optional.
  Question(this.name, this.type, this.questionText, [List<Answer>? answerList])
    : answerList = answerList ?? [];

  // XML factory constructor
  factory Question.fromXml(XmlElement questionElement) {
    Question question = Question(
      questionElement.getElement(XmlConsts.name)?.getElement(XmlConsts.text)?.innerText ?? 'UNKNOWN',
      questionElement.getAttribute(XmlConsts.type) ?? XmlConsts.essay,
      questionElement.getElement(XmlConsts.questiontext)?.getElement(XmlConsts.text)?.innerText ?? 'UNKNOWN',
    );
    for (XmlElement answerElement in questionElement.findElements(XmlConsts.answer).toList()) {
      question.answerList.add(Answer.fromXml(answerElement));
    }
    return question;
  }

  @override
  String toString() {
    final sb = StringBuffer();
    sb.write('$name\n$questionText');
    int charcode = 'A'.codeUnitAt(0);
    for (Answer answer in answerList) {
      String letter = String.fromCharCode(charcode);
      String answerStr = answer.toString();
      sb.write('\n  $letter. $answerStr');
      charcode++;
    }
    return sb.toString();
  }
}

// A single answer for a Question object. Used by all question types except for essay.
class Answer {
  String answerText;  // Multiple choice text - required
  String fraction;     // Point value from 0 (incorrect) to 100 (correct) - required
  String? feedbackText; // Feedback for the choice - optional

  // Simple constructor. Feedback param is optional.
  Answer(this.answerText, this.fraction, [this.feedbackText]);

  // XML factory constructor
  factory Answer.fromXml(XmlElement answerElement) {
    return Answer(
      answerElement.getElement(XmlConsts.text)?.innerText ?? 'UNKNOWN',
      answerElement.getAttribute(XmlConsts.fraction) ?? '100',
      answerElement.getElement(XmlConsts.feedback)?.getElement(XmlConsts.text)?.innerText
    );
  }

  @override
  String toString() {
    final sb = StringBuffer();
    sb.write(answerText);
    sb.write('  <= ($fraction%)');
    if (feedbackText != null) {
      sb.write(' - $feedbackText');
    }
    return sb.toString();
  }
}

// Object to pass user-specified parameters to LLM API.
class AssignmentForm {
  String? subject;
  String? gradeLevel;
  String? assignmentType;
  String? codingLanguage;
  Map<String, int> assignmentTypeCount = {};
  Map<String, int> codingLanguageCount = {};
}

// // Multiple choice question.
// class MultiChoiceQuestion extends Question {
//   List<QuestionChoice> choiceList = <QuestionChoice>[]; // list of multiple choice options
//
//   // Constructor
//   MultiChoiceQuestion(super.name, super.questionText, this.choiceList);
//
//   @override
//   String toString() {
//     final sb = StringBuffer();
//     sb.write('$name\n$questionText');
//     int charcode = 'A'.codeUnitAt(0);
//     for (QuestionChoice choice in choiceList) {
//       String letter = String.fromCharCode(charcode);
//       String choiceStr = choice.toString();
//       sb.write('\n  $letter. $choiceStr');
//       charcode++;
//     }
//     return sb.toString();
//   }
// }
//
// // True/false question.
// class TrueFalseQuestion extends Question {
//   bool answer;  // the correct True/False answer.
//
//   // Constructor
//   TrueFalseQuestion(super.name, super.questionText, this.answer);
//
//   @override
//   String toString() {
//     final sb = StringBuffer();
//     sb.write('$name\n$questionText\n  True\n  False\n  Correct response: $answer');
//     return sb.toString();
//   }
// }
//
// // Short answer question.
// class ShortAnswerQuestion extends Question {
//   List<String> correctAnswers = <String>[]; // list of acceptable short answers
//
//   // Constructor
//   ShortAnswerQuestion(super.name, super.questionText, this.correctAnswers);
//
//   @override
//   String toString() {
//     final sb = StringBuffer();
//     sb.write('$name\n$questionText\n');
//     String answers = correctAnswers.join(', ');
//     sb.write('  Accepted answers: $answers');
//     return sb.toString();
//   }
// }
//
// // Essay question.
// class EssayQuestion extends Question {
//   // No additional fields.
//   EssayQuestion(super.name, super.questionText);
//
//   @override
//   String toString() {
//     return '$name\n$questionText';
//   }
// }
//
// // Coding question.
// class CodingQuestion extends Question {
//   // No additional fields.
//   CodingQuestion(super.name, super.questionText);
//
//   @override
//   String toString() {
//     return '$name\n$questionText';
//   }
// }
//
// // A choice for multiple choice questions.
// class QuestionChoice {
//   String choiceText;  // Multiple choice text - required
//   int fraction;     // Point value from 0 (incorrect) to 100 (correct) - required
//   String? feedbackText; // Feedback for the choice - optional
//
//   // Constructor
//   QuestionChoice(this.choiceText, this.fraction, this.feedbackText);
//
//   @override
//   String toString() {
//     final sb = StringBuffer();
//     sb.write(choiceText);
//     sb.write(' <= $fraction%');
//     return sb.toString();
//   }
// }
