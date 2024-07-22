import 'package:flutter/material.dart';

import '../controller/main_controller.dart';


class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final MainController controller = MainController();
  String _selectedForm = '';

  void _selectForm(String formType) {
    setState(() {
      _selectedForm = formType;
    });
  }

  void _clearForm() {
    setState(() {
      _selectedForm = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IntelliGrade'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/help');
            },
          ),
          const CircleAvatar(
            backgroundImage: AssetImage('assets/avatars/ducky.jpeg'),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pushNamed(context, '/dashboard');
              },
            ),
            ListTile(
              leading: const Icon(Icons.create),
              title: const Text('Create...'),
              onTap: () {
                Navigator.pushNamed(context, '/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.view_list),
              title: const Text('View Exams'),
              onTap: () {
                Navigator.pushNamed(context, '/viewExams');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
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
                        onPressed: () {
                          _selectForm('Rubric');
                        },
                        child: const Text('Rubric'),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          _selectForm('Assignment');
                        },
                        child: const Text('Assignment'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
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
                            RubricForm(
                              onCancel: _clearForm,
                            )
                          else if (_selectedForm == 'Assignment')
                            AssignmentForm(
                              onCancel: _clearForm,
                            )
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
  const RubricForm({
    super.key,
    required this.onCancel,
  });

  @override
  _RubricFormState createState() => _RubricFormState();
}

class _RubricFormState extends State<RubricForm> {
  final MainController controller = MainController();
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

  void _showSaveDownloadDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Options'),
          content: const Text('Would you like to save or download?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                //controller.saveFileLocally(quiz)
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle download logic
              },
              child: const Text('Download'),
            ),
          ],
        );
      },
    );
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
                    // Handle form submission and generation logic
                    _showSaveDownloadDialog();
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
          ],
        ),
      ),
    );
  }
}

class AssignmentForm extends StatefulWidget {
  final VoidCallback onCancel;
  const AssignmentForm({
    super.key,
    required this.onCancel,
  });

  @override
  _AssignmentFormState createState() => _AssignmentFormState();
}

class _AssignmentFormState extends State<AssignmentForm> {
  String? _selectedSubject;
  String? _selectedGradeLevel;
  String? _selectedAssignmentType;
  String? _selectedCodingLanguage;
  bool _showRequiredResourcesTextBox = false;
  bool _showAddAssignmentTypeTextBox = false;
  bool _showAddCodingLanguageTextBox = false;
  bool _plagiarismCheck = false;
  final TextEditingController _assignmentTypeController = TextEditingController();
  final TextEditingController _codingLanguageController = TextEditingController();
  final Map<String, int> _assignmentTypeCount = {};
  final Map<String, int> _codingLanguageCount = {};

  List<String> subjects = [' ', 'Math', 'Science', 'History', 'Language Arts'];
  List<String> gradeLevels = [' ', 'Freshman', 'Sophomore', 'Junior', 'Senior'];
  List<String> assignmentTypes = ['Coding', 'Essay', 'Short Answers', 'Multiple Choice'];
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

  void _showSaveDownloadDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Options'),
          content: const Text('Would you like to save or download?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle save logic
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showDownloadOptionsDialog();
              },
              child: const Text('Download'),
            ),
          ],
        );
      },
    );
  }

  void _showDownloadOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Download Options'),
          content: const Text('Choose a download option:'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Download without answers logic goes here
              },
              child: const Text('Download without Answers'),
            ),
            if (_isDownloadWithAnswersAllowed())
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Download with answers logic goes here
                },
                child: const Text('Download with Answers'),
              ),
          ],
        );
      },
    );
  }

  bool _isDownloadWithAnswersAllowed() {
    return _assignmentTypeCount['Short Answers']! > 0 || _assignmentTypeCount['Multiple Choice']! > 0;
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
              decoration: InputDecoration(labelText: 'Duration/Deadline'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Learning Objectives'),
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
            Row(
              children: [
                const Text('Required Resources: '),
                Checkbox(
                  value: _showRequiredResourcesTextBox,
                  onChanged: (value) {
                    setState(() {
                      _showRequiredResourcesTextBox = value!;
                    });
                  },
                ),
              ],
            ),
            if (_showRequiredResourcesTextBox)
              const TextField(
                decoration: InputDecoration(labelText: 'Resources'),
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
              children: [
                const Text('Plagiarism Check: '),
                Checkbox(
                  value: _plagiarismCheck,
                  onChanged: (value) {
                    setState(() {
                      _plagiarismCheck = value!;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle form submission and generation logic
                    _showSaveDownloadDialog();
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
          ],
        ),
      ),
    );
  }
}

class EditForm extends StatelessWidget
{
  final VoidCallback onCancel;
  const EditForm({super.key, required this.onCancel});

  @override
  Widget build(BuildContext context)
  {
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




/*import 'package:flutter/material.dart';

class CreatePage extends StatefulWidget
{
  const CreatePage({super.key});

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
      appBar: AppBar(
        title: const Text('IntelliGrade'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: ()
            {
              Navigator.pushNamed(context, '/search');
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: ()
            {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: ()
            {
              Navigator.pushNamed(context, '/help');
            },
          ),
          const CircleAvatar(
            backgroundImage: AssetImage('assets/avatars/ducky.jpeg'),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pushNamed(context, '/dashboard');
              },
            ),
            ListTile(
              leading: const Icon(Icons.create),
              title: const Text('Create...'),
              onTap: () {
                Navigator.pushNamed(context, '/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.view_list),
              title: const Text('View Exams'),
              onTap: () {
                Navigator.pushNamed(context, '/viewExams');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
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
                            AssignmentForm(onCancel: _clearForm)
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
class RubricForm extends StatefulWidget
{
  final VoidCallback onCancel;
  const RubricForm({super.key, required this.onCancel});

  @override
  _RubricFormState createState() => _RubricFormState();
}

class _RubricFormState extends State<RubricForm>
{
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<TextEditingController> _criteriaControllers = [];
  String? _selectedSubject;
  String? _selectedGradeLevel;
  final List<String> subjects = ['Math', 'Science', 'History', 'Language Arts'];
  final List<String> gradeLevels = ['1000', '2000', '3000', '4000'];

  void _addCriteria()
  {
    setState(()
    {
      _criteriaControllers.add(TextEditingController());
    });
  }

  @override
  void dispose()
  {
    _titleController.dispose();
    _descriptionController.dispose();
    for (var controller in _criteriaControllers)
    {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
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
              items: subjects.map((subject)
              {
                return DropdownMenuItem(
                  value: subject,
                  child: Text(subject),
                );
              }).toList(),
              onChanged: (value)
              {
                setState(()
                {
                  _selectedSubject = value;
                });
              },
            ),
            DropdownButtonFormField<String>(
              value: _selectedGradeLevel,
              decoration: const InputDecoration(labelText: 'Grade Level/Course Level'),
              items: gradeLevels.map((level)
              {
                return DropdownMenuItem(
                  value: level,
                  child: Text(level),
                );
              }).toList(),
              onChanged: (value)
              {
                setState(()
                {
                  _selectedGradeLevel = value;
                });
              },
            ),
            const SizedBox(height: 10),
            const Text('Criteria:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ..._criteriaControllers.map((controller)
            {
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
                  onPressed: ()
                  {
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

class AssignmentForm extends StatefulWidget
{
  final VoidCallback onCancel;
  const AssignmentForm({super.key, required this.onCancel});

  @override
  _AssignmentFormState createState() => _AssignmentFormState();
}

class _AssignmentFormState extends State<AssignmentForm>
{
  String? _selectedSubject;
  String? _selectedGradeLevel;
  String? _selectedAssignmentType;
  String? _selectedCodingLanguage;
  bool _showRequiredResourcesTextBox = false;
  bool _showAddAssignmentTypeTextBox = false;
  bool _showAddCodingLanguageTextBox = false;
  bool _plagiarismCheck = false;
  final TextEditingController _assignmentTypeController = TextEditingController();
  final TextEditingController _codingLanguageController = TextEditingController();
  final Map<String, int> _assignmentTypeCount = {};
  final Map<String, int> _codingLanguageCount = {};

  List<String> subjects = [' ','Math', 'Science', 'History', 'Language Arts'];
  List<String> gradeLevels = [' ','Freshman', 'Sophomore', 'Junior', 'Senior'];
  List<String> assignmentTypes = ['Homework', 'Project', 'Essay'];
  List<String> codingLanguages = ['Python', 'Java', 'C++'];

  @override
  void initState()
  {
    super.initState();
    for (var type in assignmentTypes)
    {
      _assignmentTypeCount[type] = 0;
    }
    for (var language in codingLanguages)
    {
      _codingLanguageCount[language] = 0;
    }
  }

  void _incrementAssignmentType(String type)
  {
    setState(()
    {
      _assignmentTypeCount[type] = (_assignmentTypeCount[type] ?? 0) + 1;
    });
  }

  void _decrementAssignmentType(String type)
  {
    setState(() {
      if ((_assignmentTypeCount[type] ?? 0) > 0)
      {
        _assignmentTypeCount[type] = (_assignmentTypeCount[type] ?? 0) - 1;
      }
    });
  }

  void _incrementCodingLanguage(String language)
  {
    setState(()
    {
      _codingLanguageCount[language] = (_codingLanguageCount[language] ?? 0) + 1;
    });
  }

  void _decrementCodingLanguage(String language)
  {
    setState(()
    {
      if ((_codingLanguageCount[language] ?? 0) > 0)
      {
        _codingLanguageCount[language] = (_codingLanguageCount[language] ?? 0) - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context)
  {
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
              items: subjects.map((subject)
              {
                return DropdownMenuItem(
                  value: subject,
                  child: Text(subject),
                );
              }).toList(),
              onChanged: (value)
              {
                setState(()
                {
                  _selectedSubject = value;
                });
              },
            ),
            DropdownButtonFormField<String>(
              value: _selectedGradeLevel,
              decoration: const InputDecoration(labelText: 'Grade Level'),
              items: gradeLevels.map((grade)
              {
                return DropdownMenuItem(
                  value: grade,
                  child: Text(grade),
                );
              }).toList(),
              onChanged: (value)
              {
                setState(()
                {
                  _selectedGradeLevel = value;
                });
              },
            ),
            const SizedBox(height: 10),
            const Text('Assignment Types:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Column(
              children: assignmentTypes.map((type)
              {
                return Row(
                  children: [
                    Text(type),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: ()
                      {
                        _decrementAssignmentType(type);
                      },
                    ),
                    Text('${_assignmentTypeCount[type]}'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: ()
                      {
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
                    items: assignmentTypes.map((type)
                    {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value)
                    {
                      setState(()
                      {
                        _selectedAssignmentType = value;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: ()
                  {
                    setState(()
                    {
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
                    onPressed: ()
                    {
                      setState(()
                      {
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
              decoration: InputDecoration(labelText: 'Duration/Deadline'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Learning Objectives'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Instructions/Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            const Text('Coding Languages:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Column(
              children: codingLanguages.map((language)
              {
                return Row(
                  children: [
                    Text(language),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: ()
                      {
                        _decrementCodingLanguage(language);
                      },
                    ),
                    Text('${_codingLanguageCount[language]}'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: ()
                      {
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
                    items: codingLanguages.map((language)
                    {
                      return DropdownMenuItem(
                        value: language,
                        child: Text(language),
                      );
                    }).toList(),
                    onChanged: (value)
                    {
                      setState(()
                      {
                        _selectedCodingLanguage = value;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: ()
                  {
                    setState(()
                    {
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
                    onPressed: ()
                    {
                      setState(()
                      {
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
            Row(
              children: [
                const Text('Required Resources: '),
                Checkbox(
                  value: _showRequiredResourcesTextBox,
                  onChanged: (value)
                  {
                    setState(() {
                      _showRequiredResourcesTextBox = value!;
                    });
                  },
                ),
              ],
            ),
            if (_showRequiredResourcesTextBox)
              const TextField(
                decoration: InputDecoration(labelText: 'Resources'),
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
              children: [
                const Text('Plagiarism Check: '),
                Checkbox(
                  value: _plagiarismCheck,
                  onChanged: (value)
                  {
                    setState(() {
                      _plagiarismCheck = value!;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
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

class EditForm extends StatelessWidget
{
  final VoidCallback onCancel;
  const EditForm({super.key, required this.onCancel});

  @override
  Widget build(BuildContext context)
  {
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
}*/