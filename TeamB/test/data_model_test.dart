// test class for the data model.
import '../data_model/beans.dart';

void main() {
  var quiz = Quiz('Test Quiz', 'This is a test quiz!');

  quiz.questionList.add(MultiChoiceQuestion(
      'Multi-Choice Question',
      'What class accessor makes the class available to all other classes?',
      <QuestionChoice>[
        QuestionChoice('public', true),
        QuestionChoice('private', false),
        QuestionChoice('no accessor (package-private)', false)
      ])
  );

  quiz.questionList.add(TrueFalseQuestion('True/False Question',
      'Is Java an object-oriented language?',
      true));

  quiz.questionList.add(ShortAnswerQuestion('Short Answer Question',
      'What programming language is being used to develop IntelliGrade?',
      ['Dart', 'Flutter']));

  quiz.questionList.add(EssayQuestion('Essay Question',
      'What data structure would you use to store a collection of strings that cannot include duplicate values? Explain your answer.'));

  quiz.questionList.add(CodingQuestion('Coding Question',
      'Create a single Dart class that outputs the text "Hello World!" to console. Upload the file with a .dart extension.'));

  print(quiz);
}