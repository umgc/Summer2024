import 'package:flutter/material.dart';
import 'package:test_wizard/views/modify_test_view.dart';

class ViewAssessmentPage extends StatefulWidget {
  final String assessmentName;
  final String course;
  final String assessmentId;

  const ViewAssessmentPage({
    super.key,
    required this.assessmentName,
    required this.course,
    required this.assessmentId,
  });

  @override
  _ViewAssessmentPageState createState() => _ViewAssessmentPageState();
}

class _ViewAssessmentPageState extends State<ViewAssessmentPage> {
  // Placeholder for versions; you might want to replace this with actual data
  List<Map<String, String>> versions = [
    {'version': 'Version 1', 'student': 'John Doe', 'status': 'Completed'},
    {'version': 'Version 2', 'student': 'Jane Doe', 'status': 'In Progress'},
    {'version': 'Version 3', 'student': 'John Smith', 'status': 'Not Started'},
  ];

  void _deleteVersion(String version) {
    setState(() {
      versions.removeWhere((item) => item['version'] == version);
    });
  }

  void _printQuestionsAndAnswers() {
    // Implement print logic here
  }

  void _printQuestionsOnly() {
    // Implement print logic here
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            DataTable(
              columns: const [
                DataColumn(label: Text('Version')),
                DataColumn(label: Text('Student Name')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Actions')),
              ],
              rows: versions.map((item) {
                return DataRow(
                  cells: [
                    DataCell(
                      InkWell(
                        child: Text(
                          item['version']!,
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ModifyTestView(
                                screenTitle: item['version']!,
                                assessmentId: 'id_for_${item['version']}',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    DataCell(Text(item['student']!)),
                    DataCell(Text(item['status']!)),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteVersion(item['version']!);
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.end,
              runSpacing: 10,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Implement assign logic here
                  },
                  child: const Text('Assign'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Implement cancel logic here
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Implement save logic here
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
