import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_wizard/models/assessment_set.dart';
import 'package:test_wizard/providers/assessment_provider.dart';
import 'package:test_wizard/views/create_base_assessment_view.dart';
import 'package:test_wizard/views/login_page_view.dart';
import 'package:test_wizard/views/view_test_view.dart';
import 'package:test_wizard/widgets/scroll_container.dart';
import 'package:test_wizard/widgets/tw_app_bar.dart';
import 'package:test_wizard/providers/user_provider.dart';

class TeacherDashboard extends StatelessWidget {
  final String status;
  const TeacherDashboard({
    super.key,
    this.status = 'guest',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe6f2ff),
      appBar: TWAppBar(context: context, screenTitle: "Teacher's Dashboard", implyLeading: true,),
      body: ScrollContainer(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0), // Adjust vertical padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 5), // Space between TWAppBar and content
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Tooltip(
                    message: 'Wizard Image',
                    child: Container(
                      padding: EdgeInsets.all(5), // Adjust the padding to make space for the border
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5), // Adjust border radius for the image
                        child: Image.asset(
                          'lib/assets/wizard2.png',
                          width: 250, // Adjust the width as needed
                          height: 150, // Adjust the height as needed
                          fit: BoxFit.fitHeight, // Adjust the fit property as needed
                          semanticLabel: 'Wizard Image', // Alt text for accessibility
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (status == 'guest')
                        const Text(
                          'Login with Moodle for full access.',
                          style: TextStyle(fontSize: 14, color: Color(0xff0072bb)),
                        ),
                      const SizedBox(height: 5), // Space between text and button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          foregroundColor: Colors.white, // Ensure text color is white
                        ),
                        onPressed: () {
                          if (status != 'guest') {
                            Provider.of<UserProvider>(context, listen: false).logout();
                          }
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: Text(status == 'guest' ? 'Login with Moodle' : 'Logout'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10), // Space between image and login button
              Row(
                children: [
                  Expanded(
                    child: const Text(
                      "Assessments",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff0072bb),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0072bb),
                      foregroundColor: Colors.white, // Ensure text color is white
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CreateBaseAssessmentView(),
                        ),
                      );
                    },
                    child: const Text('Create Assessment'),
                  ),
                ],
              ),
              const SizedBox(height: 10), // Space between title and search box
              Center(
                child: const SearchFilter(), // Centered search filter
              ),
              const SizedBox(height: 20), // Space before other content
            ],
          ),
        ),
      ),
    );
  }
}

class SearchFilter extends StatefulWidget {
  const SearchFilter({super.key});

  @override
  SearchFilterState createState() => SearchFilterState();
}

class SearchFilterState extends State<SearchFilter> {
  final TextEditingController _controller = TextEditingController();
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // Center search filter content
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Search Assessments...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          onChanged: (value) {
            setState(() {
              _filter = value.toLowerCase();
            });
          },
        ),
        const SizedBox(height: 10),
        AssessmentTable(filter: _filter),
      ],
    );
  }
}

class AssessmentTable extends StatelessWidget {
  final String filter;

  const AssessmentTable({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Consumer<AssessmentProvider>(
        builder: (context, assessmentProvider, child) {
          assessmentProvider.loadAssessmentsFromFile();
          List<AssessmentSet> filteredAssessments = assessmentProvider.assessmentSets;
          if (filter.isNotEmpty) {
            filteredAssessments = assessmentProvider.assessmentSets
                .where((curr) => [curr.assessmentName, curr.course?.courseName]
                    .any((value) =>
                        value?.toLowerCase().contains(filter) ?? false))
                .toList();
          }
          return assessmentProvider.assessmentSets
                  .isEmpty // if there aren't any saved assessments
              ? const Text("We couldn't find any saved assessments.")
              // but if there are assessments display the table
              : DataTable(
                  columns: const [
                    DataColumn(label: Text('Assessment Name')),
                    DataColumn(label: Text('Course')),
                    DataColumn(label: Text('')),
                  ],
                  rows: filteredAssessments.map(
                    (assessment) {
                      return DataRow(
                        cells: [
                          DataCell(Text(assessment.assessmentName)),
                          DataCell(Text(assessment.course?.courseName ?? '')),
                          DataCell(
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => CreateViewTest(
                                      assessmentSetIndex: filteredAssessments.indexOf(assessment),
                                      assessmentName: assessment.assessmentName,
                                      courseName:
                                          assessment.course?.courseName ?? '',
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff0072bb),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Open'),
                            ),
                          ),
                        ],
                      );
                    },
                  ).toList(),
                );
        },
      ),
    );
  }
}
