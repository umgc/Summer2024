import 'package:flutter/material.dart';
import 'package:intelligrade/controller/main_controller.dart';
import 'package:intelligrade/controller/model/beans.dart' show AssignmentForm;
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
  String? _selectedAssignmentType;
  String? _selectedCodingLanguage;
  bool _showAddAssignmentTypeTextBox = false;
  bool _showAddCodingLanguageTextBox = false;
  final TextEditingController _assignmentTypeController = TextEditingController();
  final TextEditingController _codingLanguageController = TextEditingController();
  final Map<String, int> _assignmentTypeCount = {};
  final Map<String, int> _codingLanguageCount = {};

  List<String> subjects = [' ', 'Math', 'Science', 'History', 'Language Arts'];
  List<String> gradeLevels = [' ', 'Freshman', 'Sophomore', 'Junior', 'Senior'];
  List<String> assignmentTypes = ['Homework', 'Project', 'Essay'];
  List<String> codingLanguages = ['Python', 'Java', 'C++'];

  @override
  void initState() {
    super.initState();
    for (var type in assignmentTypes) {
      _assignmentTypeCount[type] = 0;
    }
    for (var language in codingLanguages) {
      _codingLanguageCount[language] = 0;
    }
  }

  void _incrementAssignmentType(String type) {
    setState(() {
      _assignmentTypeCount[type] = (_assignmentTypeCount[type] ?? 0) + 1;
    });
  }

  void _decrementAssignmentType(String type) {
    setState(() {
      if ((_assignmentTypeCount[type] ?? 0) > 0) {
        _assignmentTypeCount[type] = (_assignmentTypeCount[type] ?? 0) - 1;
      }
    });
  }

  void _incrementCodingLanguage(String language) {
    setState(() {
      _codingLanguageCount[language] = (_codingLanguageCount[language] ?? 0) + 1;
    });
  }

  void _decrementCodingLanguage(String language) {
    setState(() {
      if ((_codingLanguageCount[language] ?? 0) > 0) {
        _codingLanguageCount[language] = (_codingLanguageCount[language] ?? 0) - 1;
      }
    });
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
            const TextField(
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
            Column(
              children: assignmentTypes.map((type) {
                return Row(
                  children: [
                    Text(type),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        _decrementAssignmentType(type);
                      },
                    ),
                    Text('${_assignmentTypeCount[type]}'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        _incrementAssignmentType(type);
                      },
                    ),
                  ],
                );
              }).toList(),
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedAssignmentType,
                    decoration: const InputDecoration(labelText: 'Assignment Type'),
                    items: assignmentTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedAssignmentType = value;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _showAddAssignmentTypeTextBox = !_showAddAssignmentTypeTextBox;
                    });
                  },
                ),
              ],
            ),
            if (_showAddAssignmentTypeTextBox)
              TextField(
                controller: _assignmentTypeController,
                decoration: InputDecoration(
                  labelText: 'Add Assignment Type',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      setState(() {
                        assignmentTypes.add(_assignmentTypeController.text);
                        _selectedAssignmentType = _assignmentTypeController.text;
                        _assignmentTypeCount[_assignmentTypeController.text] = 0;
                        _showAddAssignmentTypeTextBox = false;
                        _assignmentTypeController.clear();
                      });
                    },
                  ),
                ),
              ),
            const TextField(
              decoration: InputDecoration(labelText: 'Instructions/Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            const Text('Coding Languages:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Column(
              children: codingLanguages.map((language) {
                return Row(
                  children: [
                    Text(language),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        _decrementCodingLanguage(language);
                      },
                    ),
                    Text('${_codingLanguageCount[language]}'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        _incrementCodingLanguage(language);
                      },
                    ),
                  ],
                );
              }).toList(),
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCodingLanguage,
                    decoration: const InputDecoration(labelText: 'Coding Language'),
                    items: codingLanguages.map((language) {
                      return DropdownMenuItem(
                        value: language,
                        child: Text(language),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCodingLanguage = value;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _showAddCodingLanguageTextBox = !_showAddCodingLanguageTextBox;
                    });
                  },
                ),
              ],
            ),
            if (_showAddCodingLanguageTextBox)
              TextField(
                controller: _codingLanguageController,
                decoration: InputDecoration(
                  labelText: 'Add Coding Language',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      setState(() {
                        codingLanguages.add(_codingLanguageController.text);
                        _selectedCodingLanguage = _codingLanguageController.text;
                        _codingLanguageCount[_codingLanguageController.text] = 0;
                        _showAddCodingLanguageTextBox = false;
                        _codingLanguageController.clear();
                      });
                    },
                  ),
                ),
              ),
            const TextField(
              decoration: InputDecoration(labelText: 'Key Topics'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Length/Word Count'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Format Requirements'),
            ),
            const Text('Submission Method:'),
            CheckboxListTile(
              title: const Text('Email'),
              value: false,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('School Portal'),
              value: false,
              onChanged: (value) {},
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    //build a new AssignmentForm object based on the form data
                    AssignmentForm form = AssignmentForm(
                      title: _titleController
                      subject: _selectedSubject ?? '',
                      gradeLevel: _selectedGradeLevel ?? '',
                      assignmentType: _selectedAssignmentType ?? '',
                      codingLanguages: _codingLanguageCount.keys.toList(),
                      keyTopics: ['Key Topics'],
                      length: 'Length/Word Count',
                      formatRequirements: 'Format Requirements',
                      submissionMethods: ['Email', 'School Portal'],
                      questionType: null,
                      topic: '',
                      questionCount: null,
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