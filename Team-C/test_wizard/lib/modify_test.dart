import 'package:flutter/material.dart';

void main() {
  runApp(MathQuizApp());
}

class MathQuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Quiz 1 Version 1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MathQuizScreen(),
    );
  }
}

class MathQuizScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe6f2ff),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 1200,
            padding: EdgeInsets.all(20),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color(0xffff6600),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                  child: Text(
                    'TestWizard',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                    textAlign: TextAlign.right,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xff0072bb),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
                  ),
                  child: Text(
                    'Math Quiz 1 Version 1',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                ColumnHeader(),
                QuestionRow(
                  questionId: 'question1',
                  questionText: 'Solve the equation: 3x - 7 = 11',
                  answerText: 'x = 6',
                ),
                QuestionRow(
                  questionId: 'question2',
                  questionText: 'Factor the quadratic equation: x^2 - 5x + 6 = 0',
                  answerText: '(x - 2)(x - 3) = 0',
                ),
                QuestionRow(
                  questionId: 'question3',
                  questionText: 'What is the slope of the line that passes through the points (2, 3) and (4, 7)?',
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

class ColumnHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xff0072bb),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Question',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xff0072bb),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Answer',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xff0072bb),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Previous Question',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

class QuestionRow extends StatelessWidget {
  final String questionId;
  final String questionText;
  final String answerText;

  QuestionRow({
    required this.questionId,
    required this.questionText,
    required this.answerText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: QuestionWidget(
            questionId: questionId,
            questionText: questionText,
            answerText: answerText,
          ),
        ),
        Expanded(
          child: AnswerWidget(
            answerText: answerText,
          ),
        ),
        Expanded(
          child: Container(),
        ),
      ],
    );
  }
}

class QuestionWidget extends StatelessWidget {
  final String questionId;
  final String questionText;
  final String answerText;

  QuestionWidget({
    required this.questionId,
    required this.questionText,
    required this.answerText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Question:'),
          SizedBox(height: 5),
          TextField(
            maxLines: 4,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: questionText,
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AnswerWidget extends StatelessWidget {
  final String answerText;

  AnswerWidget({required this.answerText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Answer:'),
          SizedBox(height: 5),
          TextField(
            maxLines: 4,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: answerText,
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ButtonContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () {},
            child: Text('Print'),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {},
            child: Text('Print Questions Only'),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {},
            child: Text('Add a Question'),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {},
            child: Text('Save'),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {},
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

class EditPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xff0072bb),
          ),
          onPressed: () {},
          child: Text('Edit Prompt (Advanced)'),
        ),
      ),
    );
  }
}

class DeletedQuestions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recently Deleted Questions:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: SingleChildScrollView(
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
