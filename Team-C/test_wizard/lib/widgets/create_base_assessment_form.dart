import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_wizard/utils/validators.dart';
import 'package:test_wizard/widgets/cancel_button.dart';
import 'package:test_wizard/widgets/dropdown_select.dart';

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
    // Build a Form widget using the _formKey created above.
    Size screenSize = MediaQuery.of(context).size;
    return Center(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenSize.height - kToolbarHeight * 2,
          ),
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
                      DropdownSelect(
                        controller: courseNameController,
                        dropdownTitle: 'Course',
                      ),
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
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.multiline,
                        minLines: null,
                        maxLines: 4,
                        validator: Validators.checkIsEmpty,
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
                                String assessmentName =
                                    assessmentController.text;
                                String course = courseNameController.text;
                                String numOfStudents =
                                    numOfStudentsController.text;
                                String subjectDescription =
                                    subjectDescriptionController.text;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Column(
                                      children: [
                                        Text(
                                            'Assessment: $assessmentName, Course: $course, Students: $numOfStudents, Subject: $subjectDescription'),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                            child: const Text('Generate Assessment'),
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
          ),
        ),
      ),
    );
  }
}
