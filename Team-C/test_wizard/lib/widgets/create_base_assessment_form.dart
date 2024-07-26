import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:test_wizard/providers/user_provider.dart';
import 'package:test_wizard/utils/validators.dart';
import 'package:test_wizard/widgets/cancel_button.dart';
import 'package:test_wizard/widgets/dropdown_select.dart';
import 'package:test_wizard/widgets/scroll_container.dart';
import 'package:test_wizard/models/assessment_set.dart';
import 'package:test_wizard/models/course.dart';

class CreateBaseAssessmentForm extends StatefulWidget {
  const CreateBaseAssessmentForm({super.key});

  @override
  State<CreateBaseAssessmentForm> createState() => BaseAssessmentFormState();
}

class BaseAssessmentFormState extends State<CreateBaseAssessmentForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController assessmentController = TextEditingController();
  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController numOfStudentsController = TextEditingController();
  final TextEditingController subjectDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return ScrollContainer(
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: screenSize.width * 0.8,
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Assessment Name',
                    border: OutlineInputBorder(),
                  ),
                  controller: assessmentController,
                  validator: Validators.checkIsEmpty,
                ),
                const SizedBox(height: 20),
                Consumer<UserProvider>(builder: (context, user, child) {
                  return DropdownSelect(
                    isDisabled: !user.isLoggedInToMoodle,
                    controller: courseNameController,
                    dropdownTitle: 'Course',
                  );
                }),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Number of Tests',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  controller: numOfStudentsController,
                  validator: Validators.checkIsOneOrTwoDigits,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Subject Description',
                    hintText: 'Gravitational Forces or The Rise and Fall of Rome',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.multiline,
                  validator: Validators.checkIsEmpty,
                  minLines: null,
                  maxLines: 4,
                  controller: subjectDescriptionController,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0072BB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          String assessmentName = assessmentController.text;
                          String course = courseNameController.text;
                          String numOfStudents = numOfStudentsController.text;
                          String subjectDescription = subjectDescriptionController.text;

                          // Create the new assessment set
                          final newAssessment = AssessmentSet(
                            [],
                            assessmentName,
                            Course(0, course),
                          );

                          Navigator.pop(context, newAssessment);
                        }
                      },
                      child: const Text('Create Assessment'),
                    ),
                    const SizedBox(width: 16),
                    const CancelButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
