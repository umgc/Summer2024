import 'package:flutter/material.dart';
import 'package:test_wizard/widgets/view_assessment_results_form.dart';
import 'package:test_wizard/widgets/tw_app_bar.dart';

class CreateViewAssessmentResults extends StatelessWidget {
  final String assessmentName;
  final String courseName;
  const CreateViewAssessmentResults(
      {super.key, required this.assessmentName, required this.courseName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TWAppBar(
        context: context,
        screenTitle: 'Assessment Results: $assessmentName',
        implyLeading: true,
        assessment: assessmentName,
        className: courseName,
      ),
      body: const ViewAssessmentResultsForm(),
    );
  }
}
