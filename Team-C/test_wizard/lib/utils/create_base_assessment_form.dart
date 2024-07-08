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
        widthFactor: 0.8,
        heightFactor: 0.8,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              // ** Assessment Name **
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Assessment Name',
                  border: OutlineInputBorder(),
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
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                controller: numOfStudentsController,
                validator: Validators.checkIsEmpty,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
