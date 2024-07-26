import 'package:flutter/material.dart';
import 'package:intelligrade/controller/main_controller.dart';
import 'package:intelligrade/controller/model/beans.dart'
    show AssignmentForm, Course, QuestionType;
import 'package:intelligrade/ui/header.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});
  static MainController controller = MainController();

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  String? _selectedSubject;
  String? _selectedGradeLevel;
  QuestionType? _selectedAssignmentType;
  String? _selectedCodingLanguage;
  int _numQuestions = 1;
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

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
        setState(() {
          courses = result;
        });
      });
    }
  }

  List<QuestionType> _filterAssignmentTypes() {
    if (_selectedSubject != 'Computer Science') {
      return QuestionType.values
          .where((type) => type != QuestionType.coding)
          .toList();
    }
    return QuestionType.values;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(
        title: "Create Exam",
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Create Assignment',
                    style: TextStyle(
                      fontSize: constraints.maxWidth > 600 ? 24 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: UiAssignmentForm(onCancel: () {
                        Navigator.pushReplacementNamed(context, '/viewExams');
                      }),
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
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

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
        setState(() {
          courses = result;
        });
      });
    }
  }

  List<QuestionType> _filterAssignmentTypes() {
    if (_selectedSubject != 'Computer Science') {
      return QuestionType.values
          .where((type) => type != QuestionType.coding)
          .toList();
    }
    return QuestionType.values;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  label: RichText(
                    text: const TextSpan(
                      text: 'Title',
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
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
                    _selectedAssignmentType =
                        null; // Reset assignment type when subject changes
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
              const Text('Assignment Types:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                ],
              ),
              DropdownButtonFormField<QuestionType>(
                value: _selectedAssignmentType,
                decoration: const InputDecoration(labelText: 'Question Type'),
                items: _filterAssignmentTypes().map((type) {
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
                decoration:
                    const InputDecoration(labelText: 'Descriptive Topic'),
                maxLines: 3,
              ),
              if (_selectedSubject == 'Computer Science')
                DropdownButtonFormField<String>(
                  value: _selectedCodingLanguage,
                  decoration:
                      const InputDecoration(labelText: 'Coding Language'),
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
                      if (_formKey.currentState!.validate()) {
                        // Form is valid, proceed with your logic
                        setState(() {
                          _isLoading = true;
                        });

                        // Build a new AssignmentForm object based on the form data
                        AssignmentForm form = AssignmentForm(
                          title: _titleController.text,
                          subject: _selectedSubject ?? '',
                          gradeLevel: _selectedGradeLevel ?? '',
                          questionType:
                              _selectedAssignmentType ?? QuestionType.essay,
                          codingLanguage: _selectedCodingLanguage,
                          topic: _topicController.text,
                          questionCount: _numQuestions,
                          maximumGrade: 100,
                        );

                        bool success =
                            await CreatePage.controller.createAssessments(form);
                        if (success) {
                          Navigator.pushReplacementNamed(context, '/viewExams');
                        } else {
                          // Handle failure
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to create assessments')),
                          );
                        }

                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Generate'),
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
      ),
    );
  }
}
