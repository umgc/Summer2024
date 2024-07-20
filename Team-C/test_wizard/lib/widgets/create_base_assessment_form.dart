import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_wizard/utils/validators.dart';
import 'package:test_wizard/widgets/dropdown_select.dart';
import 'package:test_wizard/widgets/generate_questions.dart';

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
  final TextEditingController assessmentTypeController =
      TextEditingController();
  final TextEditingController numOfStudentsController = TextEditingController();
  final TextEditingController subjectDescriptionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return LayoutBuilder(
      builder: (context, constraints) {
        double contextWidth = constraints.maxWidth;
        double contextHeight = constraints.maxHeight;
        double formWidth = contextWidth * 0.8;
        double formHeight = contextHeight * 0.8;
        double buttonHeight = contextHeight * 0.2;
        return SizedBox(
          width: contextWidth,
          height: contextHeight,
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: formWidth,
                  height: formHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Assessment Name',
                          border: OutlineInputBorder(),
                        ),
                        controller: assessmentController,
                        validator: Validators.checkIsEmpty,
                      ),
                      // ** Select Course Dropdown
                      DropdownSelect(
                        controller: courseNameController,
                        dropdownTitle: 'Course',
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
                      // ** Subject Description **
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Subject Description',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.multiline,
                        minLines: null,
                        maxLines: 4,
                        validator: Validators.checkIsEmpty,
                        controller: subjectDescriptionController,
                      ),
                      // ** Assessment Type **
                      DropdownSelect(
                        controller: assessmentTypeController,
                        dropdownTitle: 'Assessment Type',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: buttonHeight,
                  width: formWidth,
                  child: Row(
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
                            // String assessmentName = assessmentController.text;
                            // String course = courseNameController.text;
                            // String numOfStudents = numOfStudentsController.text;
                            // String subjectDescription =
                            //     subjectDescriptionController.text;

                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(
                            //     content: Column(
                            //       children: [
                            //         Text(
                            //             'Assessment: $assessmentName, Course: $course, Students: $numOfStudents, Subject: $subjectDescription'),
                            //         Text(
                            //           'Assessment Type: ${assessmentTypeController.text}',
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // );
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const QuestionGenerateForm(),
                              ),
                            );
                          }
                        },
                        child: const Text('Generate Assessment'),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0072BB),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
