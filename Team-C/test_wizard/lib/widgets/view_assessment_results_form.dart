import 'package:flutter/material.dart';
// import 'package:test_wizard/views/view_test_view.dart';
import 'package:test_wizard/widgets/cancel_button.dart';
import 'package:test_wizard/widgets/scroll_container.dart';

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
                DataColumn(label: Text('Student Name')),
                DataColumn(label: Text('Generated Grade')),
                DataColumn(label: Text('Override Grade')),
                DataColumn(label: Text('')),
              ],
              rows: students.map((student) {
                return DataRow(
                  cells: [
                    DataCell(Text(student['name'])),
                    DataCell(Text(student['generatedGrade'].toString())),
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
                                int.tryParse(value) ?? student['overrideGrade'];
                          });
                        },
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                student['overrideGrade'] = int.tryParse(
                                        student['overrideGrade'].toString()) ??
                                    student['overrideGrade'];
                              });
                            },
                            child: const Text('Override'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff0072bb),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              // Navigator.of(context).push(
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             const CreateViewTest()));
                            },
                            child: const Text('View this Assessment'),
                          ),
                        ],
                      ),
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
                  // Handle save action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save'),
              ),
              const SizedBox(width: 10),
              const CancelButton(),
            ],
          ),
        ],
      ),
    );
  }
}
