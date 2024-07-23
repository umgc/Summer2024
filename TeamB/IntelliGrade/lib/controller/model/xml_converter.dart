import 'package:xml/xml.dart';

import 'beans.dart';

// Static utility class for Moodle XML related functions.
class XmlConverter {

  // Convert a populated Quiz object into an XML Document.
  //
  // To get the XML String, use XmlDocument.toXmlString()
  static XmlDocument convertQuizToXml(Quiz quiz) {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    builder.element(XmlConsts.quiz, nest: () {
      // build category dummy node
      builder.element(XmlConsts.question, nest: () {
        builder.attribute(XmlConsts.type, 'category');
        builder.element('category', nest: () {
          builder.element(XmlConsts.text, nest: '\$course\$/top/LLM-Generated');
        });
      });
      for (Question question in quiz.questionList) {
        builder.element(XmlConsts.question, nest: () {
          builder.attribute(XmlConsts.type, question.type);
          builder.element(XmlConsts.name, nest: () {
            builder.element(XmlConsts.text, nest: question.name);
          });
          builder.element(XmlConsts.questiontext, nest: () {
            builder.attribute(XmlConsts.format, XmlConsts.html);
            builder.element(XmlConsts.text, nest: question.questionText);
          });
          for (Answer answer in question.answerList) {
            builder.element(XmlConsts.answer, nest: () {
              builder.attribute(XmlConsts.fraction, answer.fraction);
              builder.element(XmlConsts.text, nest: answer.answerText);
              if (answer.feedbackText != null) {
                builder.element(XmlConsts.feedback, nest: () {
                  builder.element(XmlConsts.text, nest: answer.feedbackText);
                });
              }
            });
          }
        });
      }
    });
    return builder.buildDocument();
  }


// static Quiz convertQuizXmlToObject(String xml) {
//   final obj_questions = <Question>[];
//   final document = XmlDocument.parse(xml);
//   final xml_questions = document.findElements('question').toList();
//   for (XmlElement xml_question in xml_questions) {
//     String? qType = xml_question.getAttribute('type');
//     String? qName = xml_question.xpath('/name/text').;
//     final xml_answers = xml_question.findElements('answer').toList();
//   }
//   final obj_quiz = Quiz(null, null);
// }
}