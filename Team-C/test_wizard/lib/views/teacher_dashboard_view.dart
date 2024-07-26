import 'package:flutter/material.dart';
import 'package:test_wizard/widgets/tw_app_bar.dart';
import 'package:test_wizard/views/modify_test_view.dart';
import 'package:test_wizard/views/create_base_assessment_view.dart';
import 'package:test_wizard/views/login_page_view.dart';
import 'package:test_wizard/views/view_test_view.dart'; // Ensure this import is correct
import 'package:provider/provider.dart';
import 'package:test_wizard/providers/assessment_provider.dart';
import 'package:test_wizard/providers/user_provider.dart';

class TeacherDashboard extends StatefulWidget {
  final String status;

  const TeacherDashboard({
    super.key,
    this.status = 'guest',
  });

  @override
  _TeacherDashboardState createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  List<Map<String, String>> sampleTests = [
    {'name': 'Math Quiz 1', 'course': 'Mathematics', 'percentage': '80%'},
    {'name': 'Science Test', 'course': 'Science', 'percentage': '60%'},
    {'name': 'History Quiz', 'course': 'History', 'percentage': '90%'},
  ];

  String searchQuery = '';

  void _deleteTest(String testName) {
    setState(() {
      sampleTests.removeWhere((test) => test['name'] == testName);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredTests = sampleTests
        .where((test) => test['name']!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white, // Changed background color to white
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
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Search Tests',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              if (filteredTests.isNotEmpty)
                DataTable(
                  columns: const [
                    DataColumn(label: Text('Test Name')),
                    DataColumn(label: Text('Completion Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: filteredTests.map((test) {
                    return DataRow(
                      cells: [
                        DataCell(
                          InkWell(
                            child: Text(
                              test['name']!,
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CreateViewTest(
                                    assessmentName: test['name']!,
                                    courseName: test['course']!,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        DataCell(Text(test['percentage']!)),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteTest(test['name']!);
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
