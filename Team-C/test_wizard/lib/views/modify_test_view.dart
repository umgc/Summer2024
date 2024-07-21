import 'package:flutter/material.dart';
import 'package:test_wizard/widgets/cancel_button.dart';
import 'package:test_wizard/widgets/column_header.dart';
import 'package:test_wizard/widgets/question_set.dart';
import 'package:test_wizard/widgets/scroll_container.dart';
import 'package:test_wizard/widgets/tw_app_bar.dart';

class ModifyTestView extends StatelessWidget {
  final String screenTitle;
  final String assessmentId;
  const ModifyTestView({
    super.key,
    required this.screenTitle,
    required this.assessmentId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TWAppBar(context: context, screenTitle: screenTitle),
      backgroundColor: const Color(0xffe6f2ff),
      body: ScrollContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const ColumnHeaderRow(),
            QuestionSet(assessmentId: assessmentId),
            // QuestionRow(
            //   questionId: 'question1',
            //   questionText: 'Solve the equation: 3x - 7 = 11',
            //   answerText: 'x = 6',
            // ),
            // QuestionRow(
            //   questionId: 'question2',
            //   questionText:
            //       'Factor the quadratic equation: x^2 - 5x + 6 = 0',
            //   answerText: '(x - 2)(x - 3) = 0',
            // ),
            // QuestionRow(
            //   questionId: 'question3',
            //   questionText:
            //       'What is the slope of the line that passes through the points (2, 3) and (4, 7)?',
            //   answerText: 'Slope = 2',
            // ),
            // QuestionRow(
            //   questionId: 'question4',
            //   questionText: 'Evaluate the expression: 2(3x - 4) when x = 5',
            //   answerText: '22',
            // ),
            // QuestionRow(
            //   questionId: 'question5',
            //   questionText: 'Simplify the expression: 5x - 2(x - 3)',
            //   answerText: '3x + 6',
            // ),
            const ButtonContainer(),
            const ButtonContainer2(),
            const EditPrompt(),
            const DeletedQuestions(),
          ],
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
            child: const Text('Save'),
          ),
          const SizedBox(width: 10),
          const CancelButton(),
        ],
      ),
    );
  }
}

class ButtonContainer2 extends StatelessWidget {
  const ButtonContainer2({super.key});

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
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0072BB),
                foregroundColor: Colors.white),
            child: const Text('Previous Version'),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0072BB),
                foregroundColor: Colors.white),
            child: const Text('Next Version'),
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
