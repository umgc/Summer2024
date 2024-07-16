import 'package:flutter/material.dart';
import 'package:test_wizard/widgets/tw_app_bar.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xffe6f2ff),
      appBar: TWAppBar(context: context, screenTitle: "Teacher's Dashboard"),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenSize.height,
            ),
            child: IntrinsicHeight(
              child: Container(
                width: 1200,
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
                            foregroundColor:
                                Colors.white, // Ensure text color is white
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/createAssessment');
                          },
                          child: const Text('Create Assessment'),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffff6600),
                            foregroundColor:
                                Colors.white, // Ensure text color is white
                          ),
                          onPressed: () {},
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        'For full access, login is required.',
                        style:
                            TextStyle(fontSize: 16, color: Color(0xff0072bb)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const SearchFilter(),
                  ],
                ),
              ),
            ),
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
        SizedBox(
          height: 300, // Set an appropriate height for the filtered table
          child: AssessmentTable(filter: _filter),
        ),
      ],
    );
  }
}

class AssessmentTable extends StatelessWidget {
  final String filter;

  AssessmentTable({super.key, required this.filter});

  final List<Map<String, String>> assessments = [
    {
      'name': 'Math Quiz 1',
      'course': 'Mathematics',
      'percentage': '80%',
    },
    {
      'name': 'Science Test',
      'course': 'Science',
      'percentage': '60%',
    },
    // Add more rows as needed
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredAssessments = assessments;
    if (filter.isNotEmpty) {
      filteredAssessments = assessments
          .where((assessment) => assessment.values
              .any((value) => value.toLowerCase().contains(filter)))
          .toList();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Assessment Name')),
          DataColumn(label: Text('Course')),
          DataColumn(label: Text('Percentage Complete')),
          DataColumn(label: Text('Action')),
        ],
        rows: filteredAssessments.map((assessment) {
          return DataRow(
            cells: [
              DataCell(Text(assessment['name']!)),
              DataCell(Text(assessment['course']!)),
              DataCell(Text(assessment['percentage']!)),
              DataCell(
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0072bb),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Open'),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}