// lib/widgets/qrow.dart
import 'package:flutter/material.dart';
import 'package:test_wizard/models/question.dart';

class QRow extends StatelessWidget {
  final Question question;
  final VoidCallback onEditQuestion;
  final VoidCallback onRegenerateQuestion;
  final VoidCallback onDeleteQuestion;
  final VoidCallback onEditAnswer;

  const QRow({
    super.key,
    required this.question,
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
              Text(question.questionText),
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
              Text(question.answer ?? 'no answer'),
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
