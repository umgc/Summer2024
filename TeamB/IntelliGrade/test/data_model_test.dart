// test class for the data model.

import 'package:intelligrade/controller/model/beans.dart';

void main() {
  var quiz = Quiz(name: 'Test Quiz', description: 'This is a test quiz!');

  quiz.questionList.add(Question(
      'Multi-Choice Question',
      XmlConsts.multichoice,
      'What class accessor makes the class available to all other classes?',
      <Answer>[
        Answer('public', '100'),
        Answer('private', '0'),
        Answer('no accessor (package-private)', '0')
      ])
  );

  quiz.questionList.add(Question('True/False Question',
      XmlConsts.truefalse,
      'Is Java an object-oriented language?',
      <Answer>[
        Answer('True', '100'),
        Answer('False', '0')
      ]));

  quiz.questionList.add(Question('Short Answer Question',
      XmlConsts.shortanswer,
      'What programming language is being used to develop IntelliGrade?',
      <Answer>[
        Answer('Dart', '100'),
        Answer('Flutter', '100')
      ])
  );

  quiz.questionList.add(Question('Essay Question',
      XmlConsts.essay,
      'What data structure would you use to store a collection of strings that cannot include duplicate values? Explain your answer.'
  ));

  quiz.questionList.add(Question('Coding Question',
      XmlConsts.essay,
      'Create a single Dart class that outputs the text "Hello World!" to console. Upload the file with a .dart extension.'
  ));

  print(quiz);
}