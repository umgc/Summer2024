import 'package:xml/xml.dart';

// Tags and attributes used in Moodle XML. Useful for preventing typos.
class XmlConsts {
  static const quiz = 'quiz';
  static const question = 'question';
  static const name = 'name';
  static const description = 'description';
  static const type = 'type';
  static const text = 'text';
  static const questiontext = 'questiontext';
  static const format = 'format';
  static const answer = 'answer';
  static const fraction = 'fraction';
  static const feedback = 'feedback';
  static const generalfeedback = 'generalfeedback';
  static const attachmentsrequired = 'attachmentsrequired';
  // static const rubric = 'rubric';
  static const responseformat = 'responseformat';
  static const responserequired = 'responserequired';
  static const defaultgrade = 'defaultgrade';
  // static const criteria = 'rubric_criteria';
  // static const criterion = 'criterion';
  // static const levels = 'levels';
  // static const level = 'level';
  // static const score = 'score';
  // static const definition = 'definition';
  static const responsetemplate = 'responsetemplate';
  static const graderinfo = 'graderinfo';


  // not tags but useful constants
  static const multichoice = 'multichoice';
  static const truefalse = 'truefalse';
  static const shortanswer = 'shortanswer';
  static const essay = 'essay';
  static const html = 'html';
}

// A Moodle quiz containing a list of questions.
class Quiz {
  String? name; // quiz name - optional.
  String? description; // quiz description - optional.
  List<Question> questionList = <Question>[]; // list of questions on the quiz.

  // Constructor with all optional params.
  Quiz({this.name, this.description, List<Question>? questionList})
      : questionList = questionList ?? [];

  // XML factory constructor using XML string
  factory Quiz.fromXmlString(String xmlStr) {
    Quiz quiz = Quiz();
    final document = XmlDocument.parse(xmlStr);
    final quizElement = document.getElement(XmlConsts.quiz);

    quiz.name = quizElement
        ?.getElement(XmlConsts.name)
        ?.getElement(XmlConsts.text)
        ?.innerText;

    quiz.description =
        quizElement!.getElement(XmlConsts.description)?.innerText;

    for (XmlElement questionElement
        in quizElement.findElements(XmlConsts.question)) {
      if (questionElement.getAttribute(XmlConsts.type) == 'category') {
        continue; // Skip category type questions
      }
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

// class Rubric {}

// class RubricCriteria {
//   List<RubricCriterion> criteria = <RubricCriterion>[];
//
//   // Simple constructor. criteria param is optional
//   RubricCriteria([List<RubricCriterion>? criteria]);
//
//   // XML factory constructor
//   factory RubricCriteria.fromXml(XmlElement criteriaElement) {
//     RubricCriteria rubricCriteria = RubricCriteria();
//
//     for (XmlElement criterionElement
//         in criteriaElement.findElements(XmlConsts.criteria).toList()) {
//       rubricCriteria.criteria.add(RubricCriterion.fromXml(criterionElement));
//     }
//     return rubricCriteria;
//   }
//
//   @override
//   String toString() {
//     final sb = StringBuffer();
//     // sb.write(answerText);
//     // sb.write('  <= ($fraction%)');
//     // if (feedbackText != null) {
//     //   sb.write(' - $feedbackText');
//     // }
//     return sb.toString();
//   }
// }
//
// class RubricCriterion {
//   String description;
//   List<CriterionLevel> criterionLevels = <CriterionLevel>[];
//
//   // Simple constructor. criterionLevels param is optional
//   RubricCriterion(this.description, [List<CriterionLevel>? criterionLevels]);
//
//   // XML factory constructor
//   factory RubricCriterion.fromXml(XmlElement criterionElement) {
//     RubricCriterion rubricCriterion = RubricCriterion(criterionElement
//             .getElement(XmlConsts.description)
//             ?.getElement(XmlConsts.text)
//             ?.innerText ??
//         'UNKNOWN');
//
//     for (XmlElement levelElement
//         in criterionElement.findElements(XmlConsts.levels).toList()) {
//       rubricCriterion.criterionLevels.add(CriterionLevel.fromXml(levelElement));
//     }
//     return rubricCriterion;
//   }
//
//   @override
//   String toString() {
//     final sb = StringBuffer();
//     // sb.write(answerText);
//     // sb.write('  <= ($fraction%)');
//     // if (feedbackText != null) {
//     //   sb.write(' - $feedbackText');
//     // }
//     return sb.toString();
//   }
// }
//
// class CriterionLevel {
//   String definition;
//   String score;
//
//   // Simple constructor.
//   CriterionLevel(this.definition, this.score);
//
//   // XML factory constructor
//   factory CriterionLevel.fromXml(XmlElement levelElement) {
//     return CriterionLevel(
//         levelElement
//                 .getElement(XmlConsts.definition)
//                 ?.getElement(XmlConsts.text)
//                 ?.innerText ??
//             'UNKNOWN',
//         levelElement.getElement(XmlConsts.score)?.innerText ?? 'UNKNOWN');
//   }
//
//   @override
//   String toString() {
//     final sb = StringBuffer();
//     // sb.write(answerText);
//     // sb.write('  <= ($fraction%)');
//     // if (feedbackText != null) {
//     //   sb.write(' - $feedbackText');
//     // }
//     return sb.toString();
//   }
// }

// Abstract class that represents a single question.
class Question {
  String name; // question name - required.
  String
      type; // question type (multichoice, truefalse, shortanswer, essay) - required.
  String questionText; // question text - required.
  String? generalFeedback;
  String? defaultGrade;
  String? responseFormat;
  String? responseRequired;
  String? attachmentsRequired;
  String? responseTemplate;
  String? graderInfo;
  // String description;
  List<Answer> answerList =
      <Answer>[]; // list of answers. Not needed for essay.

  // Simple constructor.
  Question({
    required this.name,
    required this.type,
    required this.questionText,
    this.generalFeedback,
    this.defaultGrade,
    this.responseFormat,
    this.responseRequired,
    this.attachmentsRequired,
    this.responseTemplate,
    this.graderInfo,
    List<Answer>? answerList,
  }) : answerList = answerList ?? [];

  // XML factory constructor
  factory Question.fromXml(XmlElement questionElement) {
    Question question = Question(
      name: questionElement
              .getElement(XmlConsts.name)
              ?.getElement(XmlConsts.text)
              ?.innerText ??
          'UNKNOWN',
      type: questionElement.getAttribute(XmlConsts.type) ?? XmlConsts.essay,
      questionText: questionElement
              .getElement(XmlConsts.questiontext)
              ?.getElement(XmlConsts.text)
              ?.innerText ??
          'UNKNOWN',
      generalFeedback: questionElement
              .getElement(XmlConsts.generalfeedback)
              ?.getElement(XmlConsts.text)
              ?.innerText,
      defaultGrade: questionElement.getElement(XmlConsts.defaultgrade)?.innerText,
      responseFormat: questionElement.getElement(XmlConsts.responseformat)?.innerText,
      responseRequired: questionElement.getElement(XmlConsts.responserequired)?.innerText,
      attachmentsRequired: questionElement.getElement(XmlConsts.attachmentsrequired)?.innerText,
      responseTemplate: questionElement.getElement(XmlConsts.responsetemplate)?.innerText,
      graderInfo: questionElement.getElement(XmlConsts.graderinfo)?.getElement(XmlConsts.text)?.innerText,
    );

    // var respformat = questionElement.getElement(XmlConsts.responseformat);
    // if (respformat != null) {
    //   question.responseformat = respformat.innerText;
    // }
    // var resprequired = questionElement.getElement(XmlConsts.responserequired);
    // if (resprequired != null) {
    //   question.responserequired = resprequired.innerText;
    // }
    // var attachrequired =
    //     questionElement.getElement(XmlConsts.attachmentsrequired);
    // if (attachrequired != null) {
    //   question.attachmentsrequired = attachrequired.innerText;
    // }

    for (XmlElement answerElement
        in questionElement.findElements(XmlConsts.answer).toList()) {
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
  String answerText; // Multiple choice text - required
  String fraction; // Point value from 0 (incorrect) to 100 (correct) - required
  String? feedbackText; // Feedback for the choice - optional

  // Simple constructor. Feedback param is optional.
  Answer(this.answerText, this.fraction, [this.feedbackText]);

  // XML factory constructor
  factory Answer.fromXml(XmlElement answerElement) {
    return Answer(
        answerElement.getElement(XmlConsts.text)?.innerText ?? 'UNKNOWN',
        answerElement.getAttribute(XmlConsts.fraction) ?? '100',
        answerElement
            .getElement(XmlConsts.feedback)
            ?.getElement(XmlConsts.text)
            ?.innerText);
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
      } =>
        Course(id, shortName, fullName),
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
  String? gradingCriteria;
  String subject;
  String topic;
  String gradeLevel;
  int maximumGrade;
  int? assignmentCount;
  int questionCount;
  String? codingLanguage;
  String title;

  AssignmentForm(
      {required this.questionType,
      required this.subject,
      required this.topic,
      required this.gradeLevel,
      required this.title,
      required this.questionCount,
      required this.maximumGrade,
      this.assignmentCount,
      this.gradingCriteria,
      this.codingLanguage});
}
