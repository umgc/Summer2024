import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_wizard/providers/assessment_provider.dart';
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
              
            );
          }).toList(),
        );
      }
    );
  
  }

  
}
