import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_wizard/providers/assessment_provider.dart';
import 'package:test_wizard/providers/user_provider.dart';
import 'package:test_wizard/WIDGETS/create_base_assessment_form.dart';

class CreateBaseAssessmentView extends StatelessWidget {
  const CreateBaseAssessmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AssessmentProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Assessment'),
        ),
        body: const CreateBaseAssessmentForm(),
      ),
    );
  }
}
