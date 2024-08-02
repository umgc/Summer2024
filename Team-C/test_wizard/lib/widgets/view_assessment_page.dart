import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_wizard/models/assessment_set.dart';
import 'package:test_wizard/providers/assessment_provider.dart';
import 'package:test_wizard/views/modify_test_view.dart';
import 'package:test_wizard/widgets/cancel_button.dart';
import 'package:test_wizard/widgets/scroll_container.dart';

class ViewAssessmentPage extends StatelessWidget {
  final String assessmentName;
  final String course;
  final int assessmentSetIndex;
  const ViewAssessmentPage({
    super.key,
    required this.assessmentSetIndex,
    required this.assessmentName,
    required this.course,

  });

  @override
  Widget build(BuildContext context) {
    return ScrollContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Consumer<AssessmentProvider>( 
            builder: (context, assessmentProvider, child) {
            AssessmentSet assessmentSet = assessmentProvider.assessmentSets[assessmentSetIndex];
              return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Version')),
              ],
              rows: assessmentProvider.getAssessmentsFromAssessmentSets(assessmentSetIndex).map((assessment) {
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
                                    '$assessmentName ${assessment.assessmentVersion}',
                                    assessmentId: assessment.assessmentId.toString(),
                                assessmentIndex: assessmentSet.assessments.indexOf(assessment),
                                assessmentSetIndex: assessmentSetIndex,
                                assessment: assessment,
                                    assessmentName: assessmentName,
                                    topic: assessmentSet.course?.topic ?? '',
                                    courseId:  assessmentSet.course?.courseId ?? 0,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          '$assessmentName ${assessment.assessmentVersion}',
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
