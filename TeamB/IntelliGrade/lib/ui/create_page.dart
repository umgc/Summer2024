import 'package:flutter/material.dart';
import 'package:intelligrade/controller/main_controller.dart';
import 'package:intelligrade/controller/model/beans.dart' show AssignmentForm, Course, QuestionType;
import 'package:intelligrade/ui/drawer.dart';
import 'package:intelligrade/ui/header.dart';

class CreatePage extends StatefulWidget
{
  const CreatePage({super.key});
  static MainController controller = MainController();

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage>
{
  String _selectedForm = '';

  void _selectForm(String formType)
  {
    setState(()
    {
      _selectedForm = formType;
    });
  }
  void _clearForm() {
    setState(()
    {
      _selectedForm = '';
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: const AppHeader(),
      drawer: const AppDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints)
        {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Create...',
                    style: TextStyle(
                      fontSize: constraints.maxWidth > 600 ? 24 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: ()
                        {
                          _selectForm('Rubric');
                        },
                        child: const Text('Rubric'),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: ()
                        {
                          _selectForm('Assignment');
                        },
                        child: const Text('Assignment'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: ()
                    {
                      _selectForm('Edit');
                    },
                    child: const Text('Edit Past Rubric/Assignment'),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (_selectedForm == 'Rubric')
                            RubricForm(onCancel: _clearForm)
                          else if (_selectedForm == 'Assignment')
                            UiAssignmentForm(onCancel: _clearForm)
                          else if (_selectedForm == 'Edit')
                              EditForm(onCancel: _clearForm),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
class RubricForm extends StatefulWidget {
  final VoidCallback onCancel;
  const RubricForm({super.key, required this.onCancel});

  @override
  _RubricFormState createState() => _RubricFormState();
}

class _RubricFormState extends State<RubricForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<TextEditingController> _criteriaControllers = [];
  String? _selectedSubject;
  String? _selectedGradeLevel;
  final List<String> subjects = ['Math', 'Science', 'History', 'Language Arts'];
  final List<String> gradeLevels = ['1000', '2000', '3000', '4000'];

  void _addCriteria() {
    setState(() {
      _criteriaControllers.add(TextEditingController());
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    for (var controller in _criteriaControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rubric Form', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            DropdownButtonFormField<String>(
              value: _selectedSubject,
              decoration: const InputDecoration(labelText: 'Subject'),
              items: subjects.map((subject) {
                return DropdownMenuItem(
                  value: subject,
                  child: Text(subject),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSubject = value;
                });
              },
            ),
            DropdownButtonFormField<String>(
              value: _selectedGradeLevel,
              decoration: const InputDecoration(labelText: 'Grade Level/Course Level'),
              items: gradeLevels.map((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Text(level),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGradeLevel = value;
                });
              },
            ),
            const SizedBox(height: 10),
            const Text('Criteria:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ..._criteriaControllers.map((controller) {
              return TextField(
                controller: controller,
                decoration: const InputDecoration(labelText: 'Criterion'),
              );
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _addCriteria,
                  child: const Text('Add Criterion'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle form submission
                  },
                  child: const Text('Generate'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: widget.onCancel,
                  child: const Text('Cancel'),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class UiAssignmentForm extends StatefulWidget {
  final VoidCallback onCancel;
  const UiAssignmentForm({super.key, required this.onCancel});

  @override
  _UiAssignmentFormState createState() => _UiAssignmentFormState();
}

class _UiAssignmentFormState extends State<UiAssignmentForm> {
  String? _selectedSubject;
  String? _selectedGradeLevel;
  QuestionType? _selectedAssignmentType;
  String? _selectedCodingLanguage;
  int _numQuestions = 1;
  bool _showAddAssignmentTypeTextBox = false;
  bool _showAddCodingLanguageTextBox = false;
  final TextEditingController _assignmentTypeController = TextEditingController();
  final TextEditingController _codingLanguageController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  // final Map<String, int> _assignmentTypeCount = {};
  // final Map<String, int> _codingLanguageCount = {};

  List<String> subjects = [
    'Math',
    'Chemistry',
    'Biology',
    'Computer Science',
    'Literature',
    'History',
    'Language Arts',
  ];
  List<String> gradeLevels = ['Freshman', 'Sophomore', 'Junior', 'Senior'];
  List<QuestionType> assignmentTypes = QuestionType.values;
  List<String> codingLanguages = ['Python', 'Java', 'C++', 'Dart'];

  List<Course> courses = [];

  @override
  void initState() {
    super.initState();

    if (MainController.isLoggedIn) {
      MainController().getCourses().then((result) {
        courses = result;
      });
    }
  }  

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Assignment Form', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Assignment Title'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedSubject,
              decoration: const InputDecoration(labelText: 'Subject'),
              items: subjects.map((subject) {
                return DropdownMenuItem(
                  value: subject,
                  child: Text(subject),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSubject = value;
                });
              },
            ),
            DropdownButtonFormField<String>(
              value: _selectedGradeLevel,
              decoration: const InputDecoration(labelText: 'Grade Level'),
              items: gradeLevels.map((grade) {
                return DropdownMenuItem(
                  value: grade,
                  child: Text(grade),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGradeLevel = value;
                });
              },
            ),
            const SizedBox(height: 10),
            const Text('Assignment Types:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              children: [
                const Text('Number of Questions'),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                      setState(() {
                        _numQuestions--;
                        if (_numQuestions < 1) _numQuestions = 1;
                      });
                  },
                ),
                Text('$_numQuestions'),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _numQuestions++;
                    });
                  },
                ),
              ]
            ),
            DropdownButtonFormField<QuestionType>(
              value: _selectedAssignmentType,
              decoration: const InputDecoration(labelText: 'Question Type'),
              items: assignmentTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.displayName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedAssignmentType = value;
                });
              },
            ),
            TextField(
              controller: _topicController,
              decoration: InputDecoration(labelText: 'Descriptive Topic'),
              maxLines: 3,
            ),
            if (_selectedSubject == 'Computer Science') 
            DropdownButtonFormField<String>(
              value: _selectedCodingLanguage,
              decoration: const InputDecoration(labelText: 'Coding Language'),
              items: codingLanguages.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCodingLanguage = value;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    //build a new AssignmentForm object based on the form data
                    AssignmentForm form = AssignmentForm(
                      title: _titleController.text,
                      subject: _selectedSubject ?? '',
                      gradeLevel: _selectedGradeLevel ?? '',
                      questionType: _selectedAssignmentType ?? QuestionType.essay,
                      codingLanguage: _selectedCodingLanguage,
                      topic: _topicController.text,
                      questionCount: _numQuestions,
                    );
                    
                    bool success = await CreatePage.controller.createAssessments(form);
                    if (success) {
                      Navigator.pushReplacementNamed(context, '/viewExams');
                    } else {
                      // Handle failure
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to create assessments')),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: widget.onCancel,
                  child: const Text('Cancel'),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class EditForm extends StatelessWidget {
  final VoidCallback onCancel;
  const EditForm({super.key, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text('Edit Past Rubric or Assignment', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const TextField(
            decoration: InputDecoration(labelText: 'Search Past Rubric or Assignment'),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text('Search'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: onCancel,
                child: const Text('Cancel'),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}