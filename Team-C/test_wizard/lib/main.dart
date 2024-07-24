import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_wizard/providers/assessment_provider.dart';
import 'package:test_wizard/providers/user_provider.dart';
import 'package:test_wizard/views/login_page_view.dart';


void main() {
  // this line ignores invalid value types when running tests on github pull request
  Provider.debugCheckInvalidValueType = null;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AssessmentProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
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
