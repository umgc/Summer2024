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

// Represents a course in Moodle.
class Course {
  int id;
  String shortName;
  String fullName;

  // Barebones constructor.
  Course(this.id, this.shortName, this.fullName);

  // Json factory constructor.
  factory Course.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'shortname': String shortName,
        'fullname': String fullName,
      } => Course(id, shortName, fullName),
      _ => throw const FormatException('Failed to load course from json.'),
    };
  }
}

enum QuestionType {
  multichoice(displayName: 'Multiple Choice', xmlName: 'multichoice'),
  truefalse(displayName: 'True/False', xmlName: 'truefalse'),
  shortanswer(displayName: 'Short Answers', xmlName: 'shortanswer'),
  essay(displayName: 'Essay', xmlName: 'essay'),
  coding(displayName: 'Coding', xmlName: 'essay');

  final String displayName;
  final String xmlName;

  const QuestionType({required this.displayName, required this.xmlName});
}

// Object to pass user-specified parameters to LLM API.
class AssignmentForm {

  QuestionType questionType;
  String subject;
  String topic;
  String gradeLevel;
  int questionCount;
  String? codingLanguage;

  AssignmentForm({
    required this.questionType,
    required this.subject,
    required this.topic,
    required this.gradeLevel,
    required this.questionCount,
    this.codingLanguage});
}
