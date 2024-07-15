import 'package:flutter/material.dart';
import 'package:test_wizard/widgets/assessment_data_editor.dart';
import 'package:test_wizard/widgets/column_header.dart';
import 'package:test_wizard/widgets/tw_app_bar.dart';

class ModifyTestView extends StatelessWidget {
  final String screenTitle;
  const ModifyTestView({super.key, required this.screenTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TWAppBar(context: context, screenTitle: screenTitle),
      backgroundColor: const Color(0xffe6f2ff),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 1200,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                ColumnHeaderRow(),
                QuestionRow(
                  questionId: 'question1',
                  questionText: 'Solve the equation: 3x - 7 = 11',
                  answerText: 'x = 6',
                ),
                QuestionRow(
                  questionId: 'question2',
                  questionText:
                      'Factor the quadratic equation: x^2 - 5x + 6 = 0',
                  answerText: '(x - 2)(x - 3) = 0',
                ),
                QuestionRow(
                  questionId: 'question3',
                  questionText:
                      'What is the slope of the line that passes through the points (2, 3) and (4, 7)?',
                  answerText: 'Slope = 2',
                ),
                QuestionRow(
                  questionId: 'question4',
                  questionText: 'Evaluate the expression: 2(3x - 4) when x = 5',
                  answerText: '22',
                ),
                QuestionRow(
                  questionId: 'question5',
                  questionText: 'Simplify the expression: 5x - 2(x - 3)',
                  answerText: '3x + 6',
                ),
                ButtonContainer(),
                EditPrompt(),
                DeletedQuestions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ColumnHeaderRow extends StatelessWidget {
  const ColumnHeaderRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: ColumnHeader(headerText: 'Question')),
        Expanded(child: ColumnHeader(headerText: 'Answer')),
        Expanded(child: ColumnHeader(headerText: 'Previous Question')),
      ],
    );
  }
}

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

class ButtonContainer extends StatelessWidget {
  const ButtonContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Wrap(
        alignment: WrapAlignment.end,
        runSpacing: 10,
        children: [
          ElevatedButton(
            onPressed: () {},
            child: const Text('Print'),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Print Questions Only'),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Add a Question'),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Save'),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class EditPrompt extends StatelessWidget {
  const EditPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xff0072bb),
          ),
          onPressed: () {},
          child: const Text('Edit Prompt (Advanced)'),
        ),
      ),
    );
  }
}

class DeletedQuestions extends StatelessWidget {
  const DeletedQuestions({super.key});

  @override
  Widget build(BuildContext context) {
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
            child: const SingleChildScrollView(
              child: Column(
                children: [
                  Text('Deleted question will be shown here...'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
