
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_wizard/utils/validators.dart';
import 'package:test_wizard/widgets/dropdown_select.dart';

class CreateViewAssessmentResultsForm extends StatefulWidget {
  const CreateViewAssessmentResultsForm({super.key});

  @override
  State<CreateViewAssessmentResultsForm> createState() => BaseViewAssessmentResultsFormState();
}

class BaseViewAssessmentResultsFormState extends State<CreateViewAssessmentResultsForm> {
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
  final TextEditingController gradingBasisController = TextEditingController();
  final TextEditingController numOfStudentsController = TextEditingController();
  final TextEditingController subjectDescriptionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> students = [
    {'name': 'John Doe', 'generatedGrade': 85, 'overrideGrade': 85},
    {'name': 'Jane Doe', 'generatedGrade': 90, 'overrideGrade': 90},
    {'name': 'John Smith', 'generatedGrade': 75, 'overrideGrade': 75},
  ];

    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xffe6f2ff),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenSize.height,
            ),
            child: IntrinsicHeight(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Color(0xffff6600),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                      ),
                      child: const Text(
                        'TestWizard',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xff0072bb),
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
                      ),
                      child: const Text(  
                        'View Assessment Results',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Search',
                        ),
                        onChanged: (value) { 
                          // Add search functionality if needed
                        },
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Student Name')),
                            DataColumn(label: Text('Generated Grade')),
                            DataColumn(label: Text('Override Grade')),
                            DataColumn(label: Text('Actions')),
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
                                        student['overrideGrade'] = int.tryParse(value) ?? student['overrideGrade'];
                                      });
                                    },
                                  ),
                                ),
                                DataCell(
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.amber,
                                      foregroundColor: Colors.black,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        student['overrideGrade'] = int.tryParse(student['overrideGrade'].toString()) ?? student['overrideGrade'];
                                      });
                                    },
                                    child: const Text('Override'),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
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
                        ElevatedButton(
                          onPressed: () {
                            // Handle cancel action
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
    /*
    
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
                      // ** Grading Basis **
                      DropdownSelect(
                        controller: gradingBasisController,
                        dropdownTitle: 'Graded On',
                      )
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
                            String assessmentName = assessmentController.text;
                            String course = courseNameController.text;
                            String numOfStudents = numOfStudentsController.text;
                            String subjectDescription =
                                subjectDescriptionController.text;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Column(
                                  children: [
                                    Text(
                                        'Assessment: $assessmentName, Course: $course, Students: $numOfStudents, Subject: $subjectDescription'),
                                    Text(
                                      'Grading Basis: ${gradingBasisController.text}, Assessment Type: ${assessmentTypeController.text}',
                                    ),
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
    );*/

