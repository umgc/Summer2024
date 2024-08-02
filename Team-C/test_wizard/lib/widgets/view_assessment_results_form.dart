import 'package:flutter/material.dart';
// import 'package:test_wizard/views/view_test_view.dart';
import 'package:test_wizard/widgets/cancel_button.dart';
import 'package:test_wizard/widgets/scroll_container.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class ViewAssessmentResultsForm extends StatefulWidget {
  const ViewAssessmentResultsForm({super.key});

  @override
  State<ViewAssessmentResultsForm> createState() =>
      AssessmentResultsFormState();
}

class AssessmentResultsFormState extends State<ViewAssessmentResultsForm> {
  List<Map<String, dynamic>> students = [
    {'id': 1, 'name': 'John Doe', 'generatedGrade': 85, 'overrideGrade': 85},
    {'id': 2, 'name': 'Jane Doe', 'generatedGrade': 90, 'overrideGrade': 90},
    {'id': 3, 'name': 'John Smith', 'generatedGrade': 75, 'overrideGrade': 75},
  ];
  @override
  Widget build(BuildContext context) {
    void setOverrideGrade(Map<String, dynamic> student, String value) {
      logger.i(student);
      logger.i(value);
      setState(() {
        students = students.map((currentStudent) {
          if (currentStudent['id'] == student['id']) {
            logger.i('changing the student grade');
            return {
              // 'id': student['id'],
              // 'name': student['name'],
              // 'generatedGrade': student['generatedGrade'],
              ...student,
              'overrideGrade': int.tryParse(value) ?? 0,
            };
          } else {
            return currentStudent;
          }
        }).toList();
      });
    }

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
                      TextFormField(
                        initialValue: student['overrideGrade'].toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setOverrideGrade(student, value);
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
