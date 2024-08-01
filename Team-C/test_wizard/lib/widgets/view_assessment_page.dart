import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_wizard/views/assessment_results_view.dart';
import 'package:test_wizard/views/modify_test_view.dart';
import 'package:test_wizard/widgets/cancel_button.dart';
import 'package:test_wizard/widgets/scroll_container.dart';

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
  State<ViewAssessmentPage> createState() => ViewTestState();
}

class ViewTestState extends State<ViewAssessmentPage> {
  final List<Map<String, dynamic>> tests = [
    {'version': 'Version 1', 'studentName': 'John Doe', 'status': 'Completed'},
    {
      'version': 'Version 2',
      'studentName': 'Jane Doe',
      'status': 'In Progress'
    },
    {
      'version': 'Version 3',
      'studentName': 'John Smith',
      'status': 'Not Started'
    },
  ];

  String topic = '';
  int courseId = 0;

  @override
  void initState() {
    super.initState();
    _loadAssessmentData();
  }

  Future<void> _loadAssessmentData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/assessments.txt');
      final fileContent = await file.readAsString();
      final jsonData = jsonDecode(fileContent);

      for (var assessmentSet in jsonData['assessmentSets']) {
        if (assessmentSet['assessmentName'] == widget.assessmentName) {
          setState(() {
            topic = assessmentSet['course']['topic'] ?? 'Default Topic';
            courseId = assessmentSet['course']['courseId'] ?? 0;
          });
          break;
        }
      }
    } catch (e) {
      print('Error reading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search',
              ),
              onChanged: (value) {
                // Add search functionality if needed
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Version')),
                DataColumn(label: Text('Student Name')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Results')),
              ],
              rows: tests.map((test) {
                return DataRow(
                  cells: [
                    DataCell(
                      GestureDetector(
                        onTap: () {
                          // Handle version click
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ModifyTestView(
                                screenTitle:
                                    '${widget.assessmentName} ${test['version']}',
                                assessmentId: widget.assessmentId,
                                assessmentName: widget.assessmentName,
                                topic: topic,
                                courseId: courseId,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          test['version'],
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text(test['studentName'])),
                    DataCell(Text(test['status'])),
                    DataCell(
                      test['status'] == 'Completed'
                          ? GestureDetector(
                              onTap: () {
                                // Handle view results click
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CreateViewAssessmentResults(
                                      assessmentName: widget.assessmentName,
                                      courseName: widget.course,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'View Results',
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            )
                          : const Text(''),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle assign action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0072bb),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Assign'),
              ),
              const SizedBox(width: 10),
              const CancelButton(),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  // Handle save action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
