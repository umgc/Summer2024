// test class for the data model.

import 'package:intelligrade/controller/model/beans.dart';

void main() {
  var quiz = Quiz(name: 'Test Quiz', description: 'This is a test quiz!');

  quiz.questionList.add(Question(
      name: 'Multi-Choice Question',
      type: XmlConsts.multichoice,
      questionText: 'What class accessor makes the class available to all other classes?',
      answerList: <Answer>[
        Answer('public', '100'),
        Answer('private', '0'),
        Answer('no accessor (package-private)', '0')
      ])
  );

  quiz.questionList.add(Question(
      name: 'True/False Question',
      type: XmlConsts.truefalse,
      questionText: 'Is Java an object-oriented language?',
      answerList: <Answer>[
        Answer('True', '100'),
        Answer('False', '0')
      ]));

  quiz.questionList.add(Question(
      name: 'Short Answer Question',
      type: XmlConsts.shortanswer,
      questionText: 'What programming language is being used to develop IntelliGrade?',
      answerList: <Answer>[
        Answer('Dart', '100'),
        Answer('Flutter', '100')
      ])
  );

  quiz.questionList.add(Question(
      name: 'Essay Question',
      type: XmlConsts.essay,
      questionText: 'What data structure would you use to store a collection of strings that cannot include duplicate values? Explain your answer.'
  ));

  quiz.questionList.add(Question(
      name: 'Coding Question',
      type: XmlConsts.essay,
      questionText: 'Create a single Dart class that outputs the text "Hello World!" to console. Upload the file with a .dart extension.'
  ));

  print(quiz);
}