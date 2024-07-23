import 'package:intelligrade/api/llm/prompt_engine.dart';
import 'package:intelligrade/controller/model/beans.dart';

void main() {
  print('Multichoice Test');
  print('------------------');
  print(PromptEngine.generatePrompt(AssignmentForm(
    questionType: QuestionType.multichoice,
    subject: 'Biology',
    topic: 'cell division',
    gradeLevel: 'Freshman',
    questionCount: 4
  )));

  print('\nTrue/False Test');
  print('------------------');
  print(PromptEngine.generatePrompt(AssignmentForm(
      questionType: QuestionType.truefalse,
      subject: 'History',
      topic: 'world war 2',
      gradeLevel: 'Junior',
      questionCount: 5
  )));

  print('\nShort Answer Test');
  print('------------------');
  print(PromptEngine.generatePrompt(AssignmentForm(
      questionType: QuestionType.shortanswer,
      subject: 'Math',
      topic: 'combinatorics',
      gradeLevel: 'Senior',
      questionCount: 2
  )));

  print('\nEssay Test');
  print('------------------');
  print(PromptEngine.generatePrompt(AssignmentForm(
      questionType: QuestionType.essay,
      subject: 'Literature',
      topic: 'American 19th century literature',
      gradeLevel: 'Freshman',
      questionCount: 1
  )));

  print('\nCoding Test');
  print('------------------');
  print(PromptEngine.generatePrompt(AssignmentForm(
      questionType: QuestionType.coding,
      subject: 'Coding',
      topic: 'recursive functions',
      gradeLevel: 'Sophomore',
      questionCount: 1,
      codingLanguage: 'Dart'
  )));
}