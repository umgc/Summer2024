import 'package:flutter/material.dart';

class QuestionRow extends StatelessWidget {
  final String question;
  final String answer;

  const QuestionRow({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Question: $question'),
          const SizedBox(height: 5),
          Text('Answer: $answer'),
        ],
      ),
    );
  }
}
