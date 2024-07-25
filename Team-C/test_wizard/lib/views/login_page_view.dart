import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_wizard/models/assessment.dart';
import 'package:test_wizard/models/assessment_set.dart';
import 'package:test_wizard/models/course.dart';
import 'package:test_wizard/models/question.dart';
import 'package:test_wizard/providers/assessment_provider.dart';
import 'package:test_wizard/views/teacher_dashboard_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe6f2ff),
      body: Center(
        child: SingleChildScrollView(
          child: FittedBox(
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: const Color(0xffff6600),
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'TestWizard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Container(
                    color: const Color(0xff0072bb),
                    padding: const EdgeInsets.all(20),
                    child: const Text(
                      'Login to TestWizard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    'lib/assets/wizard2.png', // Ensure this path is correct
                    width: 200,
                  ),
                  const SizedBox(height: 20),
                  Consumer<AssessmentProvider>(
                    builder: (context, savedAssessments, child) {
                      return ElevatedButton(
                        // for now this button populates the state with some sample data
                        // if the Moodle login button is pressed
                        onPressed: () {
                          AssessmentSet aSet = AssessmentSet(
                              [], 'Math Test', Course(1, 'Geometry 101'));
                          Assessment a = Assessment(1, 1);
                          a.questions = [
                            Question(
                              questionId: 1,
                              questionText:
                                  'How many sides does a square have?',
                              questionType: 'Short Answer',
                              answer: '4',
                              points: 10,
                            ),
                            Question(
                              questionId: 2,
                              questionText:
                                  'How many sides does a triangle have?',
                              questionType: 'Short Answer',
                              answer: '3',
                              points: 10,
                            ),
                            Question(
                              questionId: 3,
                              questionText:
                                  'How many sides does a rectangle have?',
                              questionType: 'Short Answer',
                              answer: '4',
                              points: 10,
                            ),
                          ];
                          aSet.assessments.add(a);
                          savedAssessments.add(aSet);
                          savedAssessments.saveAssessmentsToFile();
                          // Your OAuth login logic goes here
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              // to Teacher Dashboard with 'logged in' status for now
                              builder: (context) => const TeacherDashboard(
                                status: 'logged in',
                              ),
                              settings: const RouteSettings(name: '/dashboard'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0072bb),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        child: const Text('Login with Moodle'),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  // Login as Guest button still only grabs saved user data from previous time.
                  ElevatedButton(
                    onPressed: () {
                      //Guest Login here
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          // to Teacher Dashboard with no info for now
                          builder: (context) => const TeacherDashboard(),
                          settings: const RouteSettings(name: '/dashboard'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffff6600),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text('Login as Guest'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
