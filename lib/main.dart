import 'package:flutter/material.dart';

void main() {
  runApp(TeacherDashboardApp());
}

class TeacherDashboardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teacher\'s Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TeacherDashboard(),
    );
  }
}

class TeacherDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe6f2ff),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 1200,
            padding: EdgeInsets.all(20),
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
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color(0xffff6600),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                  child: Text(
                    'Welcome to TestWizard',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.right,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xff0072bb),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
                  ),
                  child: Text(
                    'Teacher\'s Dashboard',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Container(
                    width: 300,
                    child: Image.asset('assets/wizard2.png'),
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff0072bb),
                        foregroundColor: Colors.white, // Ensure text color is white
                      ),
                      onPressed: () {},
                      child: Text('Create Assessment'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xffff6600),
                        foregroundColor: Colors.white, // Ensure text color is white
                      ),
                      onPressed: () {},
                      child: Text('Login'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'For full access, login is required.',
                    style: TextStyle(fontSize: 16, color: Color(0xff0072bb)),
                  ),
                ),
                SizedBox(height: 20),
                SearchFilter(),
                SizedBox(height: 20),
                SizedBox(
                  height: 300, // Set an appropriate height for the table
                  child: AssessmentTable(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchFilter extends StatefulWidget {
  @override
  _SearchFilterState createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  TextEditingController _controller = TextEditingController();
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
        SizedBox(height: 10),
        SizedBox(
          height: 300, // Set an appropriate height for the filtered table
          child: AssessmentTable(filter: _filter),
        ),
      ],
    );
  }
}

class AssessmentTable extends StatelessWidget {
  final String? filter;

  AssessmentTable({this.filter});

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
    if (filter != null && filter!.isNotEmpty) {
      filteredAssessments = assessments
          .where((assessment) =>
              assessment.values.any((value) => value.toLowerCase().contains(filter!)))
          .toList();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
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
              DataCell(ElevatedButton(
                onPressed: () {},
                child: Text('Open'),
              )),
            ],
          );
        }).toList(),
      ),
    );
  }
}
