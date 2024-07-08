import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_wizard/utils/validators.dart';
import 'package:test_wizard/widgets/course_select.dart';

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
  final GlobalKey _formKey = GlobalKey<FormState>();
  final TextEditingController assessmentController = TextEditingController();
  final TextEditingController courseName = TextEditingController();
  final TextEditingController numOfStudentsController = TextEditingController();
  final TextEditingController subjectDescriptionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Container(
      alignment: Alignment.topCenter,
      child: FractionallySizedBox(
        widthFactor: 0.7,
        heightFactor: 0.5,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // ** Assessment Name **
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Assessment Name',
                ),
                controller: assessmentController,
                validator: Validators.checkIsEmpty,
              ),
              // ** Select Course Dropdown
              CourseSelect(
                controller: courseName,
              ),
              // ** Number of Tests **
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Number of Tests',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                controller: numOfStudentsController,
                validator: Validators.checkIsEmpty,
              )
            ],
          ),
        ),
      ),
    );
  }
}
