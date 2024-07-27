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
    String? answer=(question.questionType=='Multiple Choice') ?   'Options: ' + question.answerOptions.toString() + ' Answer: ' +(question.answer??''):question.answer;
    return Row(
      children: [
        Expanded(
          child:
          FractionallySizedBox(
            widthFactor: .95,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: (question.questionText),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: onRegenerateQuestion,
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
            ],
          ),
        ),
        ), 
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            
            children: [
              TextFormField(
                initialValue: (answer  ?? 'no answer'),
                onChanged: (value)=> {question.answer=value },
              ),
              const Text('')//my janky attempt to get these aligned
            ],
          ),
          ),
      ],
    );
  }
}
