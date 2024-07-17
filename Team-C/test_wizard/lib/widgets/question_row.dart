import 'package:flutter/material.dart';
import 'package:test_wizard/widgets/assessment_data_editor.dart';

class QuestionRow extends StatelessWidget {
  final String questionId;
  final String questionText;
  final String answerText;

  const QuestionRow({
    super.key,
    required this.questionId,
    required this.questionText,
    required this.answerText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AssessmentDataEditor(
            editorType: DataEditorType.question,
            text: questionText,
          ),
        ),
        Expanded(
          child: AssessmentDataEditor(
            editorType: DataEditorType.answer,
            text: answerText,
          ),
        ),
        Expanded(
          child: Container(),
        ),
      ],
    );
  }
}
