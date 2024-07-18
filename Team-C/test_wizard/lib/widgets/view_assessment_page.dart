import 'package:flutter/material.dart';
import 'package:test_wizard/widgets/cancel_button.dart';

class ViewAssessmentPage extends StatefulWidget {
  const ViewAssessmentPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Center(
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
                  Expanded(
                    child: SingleChildScrollView(
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
                                        },
                                        child: const Text(
                                          'View Results',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline,
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
            ),
          ),
        ),
      ),
    );
  }
}
