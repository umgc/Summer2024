import 'package:flutter/material.dart';
import 'package:test_wizard/utils/create_base_assessment_form.dart';
import 'package:test_wizard/utils/customized_widgets.dart';

class CreateBaseAssessmentView extends StatelessWidget {
  const CreateBaseAssessmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomizedWidgets.buildAppBar(context: context),
      body: const CreateBaseAssessmentForm(),
    );
  }
}
