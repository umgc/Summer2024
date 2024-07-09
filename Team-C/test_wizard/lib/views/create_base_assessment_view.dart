import 'package:flutter/material.dart';
import 'package:test_wizard/widgets/create_base_assessment_form.dart';
import 'package:test_wizard/widgets/customized_widgets.dart';

class CreateBaseAssessmentView extends StatelessWidget {
  const CreateBaseAssessmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomizedWidgets.buildAppBar(
        context: context,
        screenTitle: 'Create Assessment',
      ),
      body: const CreateBaseAssessmentForm(),
    );
  }
}
