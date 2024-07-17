import 'package:flutter/material.dart';
import 'package:test_wizard/widgets/view_assessment_results_form.dart';
import 'package:test_wizard/widgets/tw_app_bar.dart';

class CreateViewAssessmentResults extends StatelessWidget {
  const CreateViewAssessmentResults({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TWAppBar(
        context: context,
        screenTitle: 'View Assessment Results',
      ),
      body: const CreateViewAssessmentResultsForm(),
    );
  }
}