import 'package:flutter/material.dart';

class ViewAssessmentResultsForm extends StatefulWidget {
  const ViewAssessmentResultsForm({super.key});

  @override
  State<ViewAssessmentResultsForm> createState() =>
      AssessmentResultsFormState();
}

class AssessmentResultsFormState extends State<ViewAssessmentResultsForm> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> students = [
      {'name': 'John Doe', 'generatedGrade': 85, 'overrideGrade': 85},
      {'name': 'Jane Doe', 'generatedGrade': 90, 'overrideGrade': 90},
      {'name': 'John Smith', 'generatedGrade': 75, 'overrideGrade': 75},
    ];

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
                          DataColumn(label: Text('Student Name')),
                          DataColumn(label: Text('Generated Grade')),
                          DataColumn(label: Text('Override Grade')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: students.map((student) {
                          return DataRow(
                            cells: [
                              DataCell(Text(student['name'])),
                              DataCell(
                                  Text(student['generatedGrade'].toString())),
                              DataCell(
                                TextField(
                                  controller: TextEditingController(
                                    text: student['overrideGrade'].toString(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      student['overrideGrade'] =
                                          int.tryParse(value) ??
                                              student['overrideGrade'];
                                    });
                                  },
                                ),
                              ),
                              DataCell(
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber,
                                    foregroundColor: Colors.black,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      student['overrideGrade'] = int.tryParse(
                                              student['overrideGrade']
                                                  .toString()) ??
                                          student['overrideGrade'];
                                    });
                                  },
                                  child: const Text('Override'),
                                ),
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
                          // Handle save action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Save'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Handle cancel action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Cancel'),
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
