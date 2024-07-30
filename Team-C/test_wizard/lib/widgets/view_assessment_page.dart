import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_wizard/providers/assessment_provider.dart';
import 'package:test_wizard/views/modify_test_view.dart';
import 'package:test_wizard/widgets/cancel_button.dart';
import 'package:test_wizard/widgets/scroll_container.dart';

class ViewAssessmentPage extends StatefulWidget {
  final String assessmentName;
  final String course;
  final String assessmentId;
  final int assessmentSetIndex;
  const ViewAssessmentPage({
    super.key,
    required this.assessmentSetIndex,
    required this.assessmentName,
    required this.course,
    required this.assessmentId,
  });

  @override
  State<ViewAssessmentPage> createState() => ViewTestState();
}

class ViewTestState extends State<ViewAssessmentPage> {
  @override
  Widget build(BuildContext context) {
    return ScrollContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Consumer<AssessmentProvider>( 
            builder: (context, assessmentProvider, child) {
              return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Version')),
              ],
              rows: assessmentProvider.getAssessmentsFromAssessmentSets(widget.assessmentSetIndex).map((assessment) {
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
                                    '${widget.assessmentName} ${assessment.assessmentVersion}',
                                assessmentId: widget.assessmentId,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          '${widget.assessmentName} ${assessment.assessmentVersion}',
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
            );
            },
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(width: 10),
              CancelButton(),
            ],
          ),
        ],
      ),
    );
  }
}
