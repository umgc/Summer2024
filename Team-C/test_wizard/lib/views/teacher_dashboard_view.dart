import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_wizard/providers/assessment_provider.dart';
import 'package:test_wizard/providers/user_provider.dart';
import 'package:test_wizard/widgets/tw_app_bar.dart';
import 'package:test_wizard/views/modify_test_view.dart';
import 'package:test_wizard/views/create_base_assessment_view.dart';
import 'package:test_wizard/views/view_test_view.dart';
import 'package:test_wizard/views/login_page_view.dart';
import 'package:test_wizard/models/assessment_set.dart';
import 'package:test_wizard/models/course.dart';
import 'package:test_wizard/models/question.dart';
import 'package:test_wizard/models/assessment.dart'; // Ensure this import is correct

class TeacherDashboard extends StatefulWidget {
  final String status;
  final List<AssessmentSet> tests;

  const TeacherDashboard({
    super.key,
    this.status = 'guest',
    required this.tests,
  });

  @override
  _TeacherDashboardState createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  List<AssessmentSet> sampleTests = [
    AssessmentSet(
      [
        Assessment(1, 1)
          ..questions = [
            Question(
              questionId: 1,
              questionText: 'How many sides does a square have?',
              questionType: 'Short Answer',
              answer: '4',
              points: 10,
            ),
            Question(
              questionId: 2,
              questionText: 'How many sides does a triangle have?',
              questionType: 'Short Answer',
              answer: '3',
              points: 10,
            ),
            Question(
              questionId: 3,
              questionText: 'How many sides does a rectangle have?',
              questionType: 'Short Answer',
              answer: '4',
              points: 10,
            ),
          ],
      ],
      'Math Quiz 1',
      Course(1, 'Mathematics'),
    ),
    AssessmentSet(
      [],
      'Science Test',
      Course(2, 'Science'),
    ),
    AssessmentSet(
      [],
      'History Quiz',
      Course(3, 'History'),
    ),
  ];

  void _deleteTest(String testName) {
    setState(() {
      sampleTests.removeWhere((test) => test.assessmentName == testName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: TWAppBar(context: context, screenTitle: "Teacher's Dashboard"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 300,
                  child: Image.asset('lib/assets/wizard2.png'),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0072bb),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider(create: (_) => AssessmentProvider()),
                              ChangeNotifierProvider(create: (_) => UserProvider()),
                            ],
                            child: const CreateBaseAssessmentView(),
                          ),
                        ),
                      );
                    },
                    child: const Text('Create Assessment'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffff6600),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: Text(widget.status == 'guest' ? 'Login with Moodle' : 'Logout'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              widget.status == 'guest'
                  ? const Center(
                      child: Text(
                        'For full access, login is required.',
                        style: TextStyle(fontSize: 16, color: Color(0xff0072bb)),
                      ),
                    )
                  : const SizedBox(height: 0),
              const SizedBox(height: 20),
              if (sampleTests.isNotEmpty)
                DataTable(
                  columns: const [
                    DataColumn(label: Text('Test Name')),
                    DataColumn(label: Text('Completion Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: sampleTests.map((test) {
                    return DataRow(
                      cells: [
                        DataCell(
                          InkWell(
                            child: Text(
                              test.assessmentName,
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CreateViewTest(
                                    assessmentName: test.assessmentName,
                                    courseName: test.course?.courseName ?? 'Unknown',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const DataCell(Text('0%')),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteTest(test.assessmentName);
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
