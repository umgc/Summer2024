import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_wizard/models/assessment_set.dart';
import 'package:test_wizard/providers/assessment_provider.dart';
import 'package:test_wizard/views/create_base_assessment_view.dart';
import 'package:test_wizard/views/login_page_view.dart';
import 'package:test_wizard/views/view_test_view.dart';
import 'package:test_wizard/widgets/scroll_container.dart';
import 'package:test_wizard/widgets/tw_app_bar.dart';

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
      appBar: TWAppBar(context: context, screenTitle: "Teacher's Dashboard"),
      body: ScrollContainer(
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
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffff6600),
                    foregroundColor: Colors.white, // Ensure text color is white
                  ),
                  onPressed: () {
                    // put in logic for checking if logged in and then logging out if necessary
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child:
                      Text(status == 'guest' ? 'Login with Moodle' : 'Logout'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            status == 'guest'
                ? const Center(
                    child: Text(
                      'For full access, login is required.',
                      style: TextStyle(fontSize: 16, color: Color(0xff0072bb)),
                    ),
                  )
                : const SizedBox(
                    height: 0,
                  ),
            const SizedBox(height: 20),
            const SearchFilter(),
          ],
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Search...',
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
        builder: (context, savedAssessments, child) {
          List<AssessmentSet> filteredAssessments = savedAssessments.assessmentSets;
          if (filter.isNotEmpty) {
            filteredAssessments = savedAssessments.assessmentSets
                .where((curr) => [curr.assessmentName, curr.course?.courseName]
                    .any((value) =>
                        value?.toLowerCase().contains(filter) ?? false))
                .toList();
          }
          return !savedAssessments.assessmentSets
                  .isNotEmpty // if there aren't any saved assessments
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
