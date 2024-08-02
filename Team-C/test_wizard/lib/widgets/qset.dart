import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_wizard/providers/assessment_provider.dart';
import 'package:test_wizard/models/question.dart';
import 'package:test_wizard/widgets/qrow.dart';

class QSet extends StatelessWidget {
  final String assessmentId;
  final int assessmentIndex;
  final int assessmentSetIndex;

  const QSet({
    super.key,
    required this.assessmentId,
    required this.assessmentIndex,
    required this.assessmentSetIndex
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AssessmentProvider>( 
      builder: (context, assessmentProvider, child) {
        return Column(
          children: assessmentProvider.getAssessmentFromAssessmentSet(assessmentSetIndex, assessmentIndex).questions.map((question) {
            return QRow(
              question: question,
              onEditQuestion: () {
                _showEditDialog(context, question, isQuestion: true);
              },
              onRegenerateQuestion: () {
                _showEditDialog(context, question, isQuestion: true, isRegenerate: true);
              },
              onDeleteQuestion: () {
                assessmentProvider.removeQuestion(assessmentProvider.getAssessmentFromAssessmentSet(assessmentSetIndex, assessmentIndex).questions.indexOf(question));
              },
              onEditAnswer: () {
                _showEditDialog(context, question, isQuestion: false);
              },
            );
          }).toList(),
        );
      }
    );
  
  }

  void _showEditDialog(BuildContext context, Question question,
      {bool isQuestion = true, bool isRegenerate = false}) {
    final TextEditingController controller = TextEditingController(
      text: isQuestion ? question.questionText : question.answer,
    );
    Consumer<AssessmentProvider>( 
      builder: (context, assessmentProvider, child)  { 
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
            );
          },
        );
      throw Exception();});
      }
}
