// lib/widgets/qrow.dart
import 'package:flutter/material.dart';
import 'package:test_wizard/models/question.dart';


class QRow extends StatelessWidget {
  final Question question;
  
  
  const QRow({
    super.key,
    required this.question,
    

  });

  @override
  Widget build(BuildContext context) {
    String? answer=(question.questionType=='multipleChoice') ?   'Options: ${question.answerOptions} Answer: ${question.answer??''}':question.answer;
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
                onChanged: (value)=> {question.questionText=value},
              ),
              // Row(
              //   children: [
              //     IconButton(
              //       onPressed: onRegenerateQuestion,
              //       icon: const Icon(Icons.refresh),
              //     ),
              //   ],
              // ),
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
            ],
          ),
          ),
      ],
    );
  }
}
