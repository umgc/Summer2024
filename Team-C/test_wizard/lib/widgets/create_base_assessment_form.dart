import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:test_wizard/providers/user_provider.dart';
import 'package:test_wizard/utils/validators.dart';
import 'package:test_wizard/widgets/cancel_button.dart';
import 'package:test_wizard/widgets/dropdown_select.dart';
import 'package:test_wizard/views/generate_questions.dart';
import 'package:test_wizard/widgets/scroll_container.dart';

class CreateBaseAssessmentForm extends StatefulWidget {
  const CreateBaseAssessmentForm({super.key});

  @override
  State<CreateBaseAssessmentForm> createState() => BaseAssessmentFormState();
}

class BaseAssessmentFormState extends State<CreateBaseAssessmentForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController assessmentController = TextEditingController();
  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController numOfStudentsController = TextEditingController();
  final TextEditingController subjectDescriptionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    // Prepare the course names from the filtered courses
    List<Map<String, dynamic>> courseNames = userProvider.courses;
    // Build a Form widget using the _formKey created above.
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
                const SizedBox(
                  height: 20,
                ),
                // ** Select Course Dropdown
                Consumer<UserProvider>(builder: (context, user, child) {
                  return DropdownSelect(
                    isDisabled: !user.isLoggedInToMoodle,
                    controller: courseNameController,
                    dropdownTitle: 'Course',
                    options: courseNames,
                  );
                }),
                const SizedBox(
                  height: 20,
                ),
                // ** Number of Tests **
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Number of Tests',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: numOfStudentsController,
                  validator: Validators.checkIsOneOrTwoDigits,
                ),
                const SizedBox(
                  height: 20,
                ),
                // ** Subject Description **
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Subject Description',
                    hintText:
                        'Gravitational Forces or The Rise and Fall of Rome',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.multiline,
                  validator: Validators.checkIsEmpty,
                  minLines: null,
                  maxLines: 4,
                  controller: subjectDescriptionController,
                ),
                const SizedBox(
                  height: 20,
                ),
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
                          String subjectDescription =
                              subjectDescriptionController.text;

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => QuestionGenerateForm(
                                courseName: course,
                                assessmentName: assessmentName,
                                numberOfAssessments: int.parse(numOfStudents),
                                topic: subjectDescription,
                              ),
                            ),
                          );

                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     content: Column(
                          //       children: [
                          //         Text(
                          //             'Assessment: $assessmentName, Course: $course, Students: $numOfStudents, Subject: $subjectDescription'),
                          //       ],
                          //     ),
                          //   ),
                          // );
                        }
                      },
                      child: const Text('Add Questions'),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
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
