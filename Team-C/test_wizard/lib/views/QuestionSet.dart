import 'package:flutter/material.dart';
import 'package:test_wizard/widgets/question_row.dart';

class QuestionSet extends StatelessWidget {
  final List<QuestionAnswer> questionsAndAnswers;

  const QuestionSet({super.key, required this.questionsAndAnswers});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: questionsAndAnswers
          .map((qa) => QuestionRow(question: qa.question, answer: qa.answer))
          .toList(),
    );
  }
}
