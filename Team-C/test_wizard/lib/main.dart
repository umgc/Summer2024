import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_wizard/providers/assessment_provider.dart';
import 'package:test_wizard/views/create_base_assessment_view.dart';
import 'package:test_wizard/providers/user_provider.dart';
import 'package:test_wizard/views/assessment_results_view.dart';
import 'package:test_wizard/views/login_page_view.dart';
import 'package:test_wizard/views/modify_test_view.dart';
import 'package:test_wizard/views/teacher_dashboard_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AssessmentProvider()),
        Provider(create: (context) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Wizard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      // *** The named route method is discouraged by the flutter team ***
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => const TeacherDashboard(),
      //   '/createAssessment': (context) => const CreateBaseAssessmentView(),
      //   '/modifyTest': (context) => const ModifyTestView(
      //         screenTitle: 'Math Quiz',
      //         assessmentId: 'MQ1V1',
      //       ),
      //   '/login': (context) => const LoginPage(),
      //   '/viewAssessment': (context) => const CreateViewAssessmentResults(),
      // },
      home: const LoginPage(),
    );
  }
}
