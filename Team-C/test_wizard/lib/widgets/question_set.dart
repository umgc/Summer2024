import 'package:flutter/material.dart';
import 'package:test_wizard/models/temp.dart';
import 'package:test_wizard/utils/question.dart';
import 'package:test_wizard/widgets/question_row.dart';

class QuestionSet extends StatelessWidget {
  final Future<List<Question>> Function(String) future;
  final String assessmentId;
  const QuestionSet({
    super.key,
    this.future = TempModel.fetchQuestions,
    required this.assessmentId,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Question>>(
      future: future(assessmentId),
      builder: (BuildContext context, AsyncSnapshot<List<Question>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Column(
            children: snapshot.data!.map<QuestionRow>((Question question) {
              return QuestionRow(
                questionId: question.questionId,
                questionText: question.questionText,
                answerText: question.answerText,
              );
            }).toList(),
          );
        }
      },
    );
  }
}
