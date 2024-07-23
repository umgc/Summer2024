// lib/widgets/qrow.dart
import 'package:flutter/material.dart';
import 'package:test_wizard/models/question_answer_model.dart';

class QRow extends StatelessWidget {
  final QuestionAnswer questionAnswer;
  final VoidCallback onEditQuestion;
  final VoidCallback onRegenerateQuestion;
  final VoidCallback onDeleteQuestion;
  final VoidCallback onEditAnswer;

  const QRow({
    super.key,
    required this.questionAnswer,
    required this.onEditQuestion,
    required this.onRegenerateQuestion,
    required this.onDeleteQuestion,
    required this.onEditAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(questionAnswer.questionText),
              Row(
                children: [
                  IconButton(
                    onPressed: onEditQuestion,
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: onRegenerateQuestion,
                    icon: const Icon(Icons.refresh),
                  ),
                  IconButton(
                    onPressed: onDeleteQuestion,
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(questionAnswer.answerText),
              IconButton(
                onPressed: onEditAnswer,
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
