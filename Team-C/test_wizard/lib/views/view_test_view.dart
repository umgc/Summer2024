import 'package:flutter/material.dart';
import 'package:test_wizard/widgets/tw_app_bar.dart';
import 'package:test_wizard/widgets/view_assessment_page.dart';

class CreateViewTest extends StatelessWidget {
  const CreateViewTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TWAppBar(
        context: context,
        screenTitle: 'View Quiz',
        implyLeading: true,
      ),
      body: const ViewAssessmentPage(),
    );
  }
}
