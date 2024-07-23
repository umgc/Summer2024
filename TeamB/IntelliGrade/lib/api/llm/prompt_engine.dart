import 'package:intelligrade/controller/model/beans.dart';

class PromptEngine {

  static const prompt_quizgen_choice = 'Generate a multiple choice quiz in XML format '
      'that is compatible with Moodle XML import.  The quiz is to be on the subject of '
      '[subject] and should be related to [topic]. '
      'The quiz should be the same level of difficulty for college [gradelevel] students of the '
      'English-speaking language.  The quiz should have [numquestions] questions. ';

  static const prompt_quizgen_truefalse = 'Generate a true/false quiz in XML format '
      'that is compatible with Moodle XML import.  The quiz is to be on the subject of '
      '[subject] and should be related to [topic]. '
      'The quiz should be the same level of difficulty for college [gradelevel] students of the '
      'English-speaking language.  The quiz should have [numquestions] questions. ';

  static const prompt_quizgen_shortanswer = 'Generate a short answer assignment in XML '
      'format that is compatible with Moodle XML import.  The assignment is to be on the '
      'subject of [subject] and should be related to [topic]. '
      'The assignment should be the same level of difficulty for college [gradelevel] students of the '
      'English-speaking language. The assignment should have [numquestions] questions.  ';

  static const prompt_quizgen_essay = 'Generate an essay assignment in XML format that '
      'is compatible with Moodle XML import. The assignment is to be on the subject of [subject] '
      'and should be related to [topic]. '
      'The assignment should be the same level of difficulty for college [gradelevel] students of the '
      'English-speaking language.  ';

  static const prompt_quizgen_code = 'Generate a coding assignment in XML format '
      'that is compatible with Moodle XML import.  The assignment is to be on the subject of '
      '[subject], should be related to [topic], and the programming language should be [codinglanguage]. '
      'The assignment should be the same level of difficulty for college [gradelevel] '
      'students of the English-speaking language.  The question type should be essay.  ';

  static const prompt_quizgen_xmlonly = 'Provide only the XML in your response.';

  static String generatePrompt(AssignmentForm form) {
    String prompt;
    switch (form.questionType) {
      case QuestionType.multichoice:
        prompt = prompt_quizgen_choice;
        break;
      case QuestionType.truefalse:
        prompt = prompt_quizgen_truefalse;
        break;
      case QuestionType.shortanswer:
        prompt = prompt_quizgen_shortanswer;
        break;
      case QuestionType.essay:
        prompt = prompt_quizgen_essay;
        break;
      case QuestionType.coding:
        prompt = prompt_quizgen_code;
        break;
    }
    prompt = prompt
        .replaceAll('[subject]', form.subject)
        .replaceAll('[topic]', form.topic)
        .replaceAll('[gradelevel]', form.gradeLevel)
        .replaceAll('[numquestions]', form.questionCount.toString());
    if (form.codingLanguage != null) {
      prompt = prompt.replaceAll('[codinglanguage]', form.codingLanguage!);
    }
    prompt += prompt_quizgen_xmlonly;
    return prompt;
  }
}