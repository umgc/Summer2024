import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_wizard/providers/question_answer_provider.dart';

class DeletedQuestions extends StatelessWidget {
  const DeletedQuestions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deletedQuestions = Provider.of<QuestionAnswerProvider>(context).deletedQuestions;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recently Deleted Questions:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: deletedQuestions.map((qa) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(qa.questionText),
                      ElevatedButton(
                        onPressed: () {
                          Provider.of<QuestionAnswerProvider>(context, listen: false)
                              .restoreQuestion(qa);
                        },
                        child: const Text('Restore'),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
