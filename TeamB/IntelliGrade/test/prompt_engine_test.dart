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
      questionCount: 4,
      title: 'Multichoice Test',
      maximumGrade: 50)));

  print('\nTrue/False Test');
  print('------------------');
  print(PromptEngine.generatePrompt(AssignmentForm(
      questionType: QuestionType.truefalse,
      subject: 'History',
      topic: 'world war 2',
      gradeLevel: 'Junior',
      questionCount: 5,
      title: 'True/False Test',
      maximumGrade: 20)));

  print('\nShort Answer Test');
  print('------------------');
  print(PromptEngine.generatePrompt(AssignmentForm(
      questionType: QuestionType.shortanswer,
      subject: 'Math',
      topic: 'combinatorics',
      gradeLevel: 'Senior',
      questionCount: 2,
      title: 'Short Answer Test',
      maximumGrade: 20)));

  print('\nEssay Test');
  print('------------------');
  print(PromptEngine.generatePrompt(AssignmentForm(
      questionType: QuestionType.essay,
      subject: 'Literature',
      topic: 'American 19th century literature',
      gradeLevel: 'Freshman',
      questionCount: 1,
      title: 'Essay Test',
      gradingCriteria:
          "American Revolutionary Period, Transcendentalism movement and the dark side of American History",
      maximumGrade: 100)));

  print('\nCoding Test');
  print('------------------');
  print(PromptEngine.generatePrompt(AssignmentForm(
      questionType: QuestionType.coding,
      subject: 'Coding',
      topic: 'recursive functions',
      gradeLevel: 'Sophomore',
      questionCount: 1,
      codingLanguage: 'Dart',
      title: 'Coding Test',
      gradingCriteria: "tree structure and list structure",
      maximumGrade: 50)));
}
