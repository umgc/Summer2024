import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_wizard/models/question_answer_model.dart';
import 'package:test_wizard/providers/question_answer_provider.dart';
import 'package:test_wizard/widgets/qrow.dart';

class QSet extends StatelessWidget {
  final String assessmentId;

  const QSet({
    super.key,
    required this.assessmentId,
  });

  @override
  Widget build(BuildContext context) {
    final questionAnswers = Provider.of<QuestionAnswerProvider>(context).questions;

    return Column(
      children: questionAnswers.map((qa) {
        return QRow(
          questionAnswer: qa,
          onEditQuestion: () {
            _showEditDialog(context, qa, isQuestion: true);
          },
          onRegenerateQuestion: () {
            _showEditDialog(context, qa, isQuestion: true, isRegenerate: true);
          },
          onDeleteQuestion: () {
            Provider.of<QuestionAnswerProvider>(context, listen: false)
                .deleteQuestion(qa.questionText);
          },
          onEditAnswer: () {
            _showEditDialog(context, qa, isQuestion: false);
          },
        );
      }).toList(),
    );
  }

    void _showEditDialog(BuildContext context, QuestionAnswer qa,
      {bool isQuestion = true, bool isRegenerate = false}) {
    final TextEditingController controller = TextEditingController(
      text: isQuestion ? qa.questionText : qa.answerText,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isQuestion ? 'Edit Question' : 'Edit Answer'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: isQuestion ? 'Question' : 'Answer',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (isQuestion) {
                  if (isRegenerate) {
                    Provider.of<QuestionAnswerProvider>(context, listen: false)
                        .regenerateQuestion(qa.questionText, controller.text);
                  } else {
                    Provider.of<QuestionAnswerProvider>(context, listen: false)
                        .updateQuestion(qa.questionText, controller.text);
                  }
                } else {
                  Provider.of<QuestionAnswerProvider>(context, listen: false)
                      .updateAnswer(qa.questionText, controller.text);
                }
                Navigator.of(context).pop();
              },
              child: Text(isRegenerate ? 'Regenerate' : 'Save'),
            ),
          ],
        );
      },
    );
  }
}
