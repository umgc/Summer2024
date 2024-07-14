import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuestionDetail extends StatefulWidget {
  const QuestionDetail({super.key});

  @override
  _QuestionDetailState createState() => _QuestionDetailState();
}

class _QuestionDetailState extends State<QuestionDetail> {
  final List<Map<String, dynamic>> questions = [
    {
      "type": "multiple_choice",
      "question": "Which of the following is the primary function of ribosomes in a cell?",
      "choices": ["Photosynthesis", "Protein synthesis", "Lipid synthesis", "DNA replication"],
      "answer": "Protein synthesis"
    },
    {
      "type": "short_answer",
      "question": "Define photosynthesis.",
      "answer": "Photosynthesis is the process by which green plants use sunlight to synthesize foods."
    },
  ];

  int _currentQuestionIndex = 0;
  bool _isModified = false;
  bool _isEditingQuestion = false;
  List<bool> _isEditingChoice = [];
  bool _isEditingAnswer = false;
  bool _showDetailPage = false;
  bool _isEditingTitle = false;
  String _assignmentTitle = 'Assignment Title';
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _initializeEditingChoice();
    _titleController = TextEditingController(text: _assignmentTitle);
  }

  void _initializeEditingChoice() {
    if (questions.isNotEmpty && questions[_currentQuestionIndex]['type'] == 'multiple_choice') {
      _isEditingChoice = List.filled(questions[_currentQuestionIndex]['choices'].length, false);
    } else {
      _isEditingChoice = [];
    }
  }

  void _navigateToPreviousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _resetEditingState();
      });
    }
  }

  void _navigateToNextQuestion() {
    if (_currentQuestionIndex < questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _resetEditingState();
      });
    }
  }

  void _resetEditingState() {
    _isEditingQuestion = false;
    _isEditingAnswer = false;
    _initializeEditingChoice();
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Unsaved Changes'),
          content: const Text('You have unsaved changes. Are you sure you want to leave without saving?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/create');
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _toggleEditQuestion() {
    setState(() {
      _isEditingQuestion = !_isEditingQuestion;
    });
  }

  void _toggleEditChoice(int index) {
    setState(() {
      _isEditingChoice[index] = !_isEditingChoice[index];
    });
  }

  void _toggleEditAnswer() {
    setState(() {
      _isEditingAnswer = !_isEditingAnswer;
    });
  }

  void _addChoice() {
    setState(() {
      questions[_currentQuestionIndex]['choices'].add('');
      _isEditingChoice.add(true);
    });
  }

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('EEE MMM d, yyyy');
    return formatter.format(date);
  }

  void _navigateToDetailPage(int index) {
    setState(() {
      _currentQuestionIndex = index;
      _showDetailPage = true;
      _resetEditingState();
    });
  }

  void _deleteQuestion(int index) {
    setState(() {
      questions.removeAt(index);
      if (_currentQuestionIndex >= questions.length && _currentQuestionIndex > 0) {
        _currentQuestionIndex--;
      }
      _resetEditingState();
    });
  }

  void _editTitle() {
    setState(() {
      _isEditingTitle = true;
    });
  }

  void _saveTitle() {
    setState(() {
      _isEditingTitle = false;
      _assignmentTitle = _titleController.text;
    });
  }

  void _addQuestion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String type = 'multiple_choice';
        String question = '';
        List<String> choices = ['', ''];
        String answer = '';
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Question'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: type,
                      decoration: const InputDecoration(labelText: 'Question Type'),
                      items: ['multiple_choice', 'short_answer', 'essay', 'coding'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          type = newValue!;
                          if (type == 'multiple_choice') {
                            choices = ['', ''];
                          } else {
                            choices = [];
                          }
                        });
                      },
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Question'),
                      onChanged: (value) {
                        question = value;
                      },
                    ),
                    if (type == 'multiple_choice')
                      ...choices.asMap().entries.map((entry) {
                        int index = entry.key;
                        return Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(labelText: 'Choice ${index + 1}'),
                                onChanged: (value) {
                                  choices[index] = value;
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  choices.removeAt(index);
                                });
                              },
                            ),
                          ],
                        );
                      }),
                    if (type == 'multiple_choice')
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            choices.add('');
                          });
                        },
                      ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Answer'),
                      onChanged: (value) {
                        answer = value;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      questions.add({
                        "type": type,
                        "question": question,
                        "choices": choices,
                        "answer": answer,
                      });
                      Navigator.of(context).pop();
                    });
                  },
                  child: const Text('Add'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var currentQuestion = questions.isNotEmpty ? questions[_currentQuestionIndex] : null;
    String formattedDate = _formatDate(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Details'),
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
      body: _showDetailPage && currentQuestion != null
          ? _buildQuestionDetail(context, currentQuestion, formattedDate)
          : _buildQuestionList(),
      floatingActionButton: _isModified
          ? FloatingActionButton(
        onPressed: () {
          // Save functionality here
        },
        child: const Icon(Icons.save),
      )
          : null,
    );
  }

  Widget _buildQuestionList() {
    return Center(
      child: SizedBox(
        width: 600,
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _isEditingTitle
                        ? Expanded(
                      child: TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: 'Edit Title'),
                        onChanged: (value) {
                          setState(() {
                            _assignmentTitle = value;
                          });
                        },
                      ),
                    )
                        : Expanded(
                      child: Text(
                        _assignmentTitle,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (_isEditingTitle)
                      IconButton(
                        icon: const Icon(Icons.save),
                        onPressed: _saveTitle,
                      )
                    else
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: _editTitle,
                      ),
                    ElevatedButton(
                      onPressed: _addQuestion,
                      child: const Text('Add Question'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(questions[index]['question']),
                        subtitle: Text('Type: ${questions[index]['type']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _navigateToDetailPage(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteQuestion(index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/create');
                  },
                  child: const Text('Back'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionDetail(BuildContext context, Map<String, dynamic> currentQuestion, String formattedDate) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            color: Colors.pink[50],
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _isEditingQuestion
                            ? TextField(
                          controller: TextEditingController(text: currentQuestion['question']),
                          decoration: const InputDecoration(
                            labelText: 'Edit Question',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: null,
                          onChanged: (value) {
                            _isModified = true;
                            currentQuestion['question'] = value;
                          },
                        )
                            : Text(
                          currentQuestion['question'],
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'DATE CREATED\n$formattedDate',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: Icon(_isEditingQuestion ? Icons.check : Icons.edit),
                    onPressed: _toggleEditQuestion,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Summary',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: Colors.deepPurple,
                  thickness: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: [
                if (currentQuestion['type'] == 'multiple_choice')
                  Card(
                    elevation: 2,
                    child: Column(
                      children: [
                        const ListTile(
                          title: Text(
                            'CHOICES',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Text('EDIT/DELETE'),
                        ),
                        const Divider(),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: currentQuestion['choices'].length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              child: Row(
                                children: [
                                  Text(
                                    '${String.fromCharCode(65 + index)}.',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _isEditingChoice[index]
                                        ? TextField(
                                      controller: TextEditingController(
                                          text: currentQuestion['choices'][index]),
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (value) {
                                        _isModified = true;
                                        currentQuestion['choices'][index] = value;
                                      },
                                    )
                                        : Text(
                                      currentQuestion['choices'][index],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(_isEditingChoice[index] ? Icons.check : Icons.edit),
                                    onPressed: () => _toggleEditChoice(index),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        currentQuestion['choices'].removeAt(index);
                                        _isEditingChoice.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _addChoice,
                          child: const Text('Add Choice'),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 10),
                Card(
                  elevation: 2,
                  child: ListTile(
                    title: const Text(
                      'Answer',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: _isEditingAnswer
                              ? TextField(
                            controller: TextEditingController(text: currentQuestion['answer']),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              _isModified = true;
                              currentQuestion['answer'] = value;
                            },
                          )
                              : Text(
                            currentQuestion['answer'],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        IconButton(
                          icon: Icon(_isEditingAnswer ? Icons.check : Icons.edit),
                          onPressed: _toggleEditAnswer,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _navigateToPreviousQuestion,
                child: const Text('Previous Question'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_isModified) {
                    _showConfirmationDialog(context);
                  } else {
                    setState(() {
                      _showDetailPage = false;
                    });
                  }
                },
                child: const Text('Back to List'),
              ),
              ElevatedButton(
                onPressed: _navigateToNextQuestion,
                child: const Text('Next Question'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
/*import 'package:flutter/material.dart';

class QuestionDetail extends StatelessWidget {
  const QuestionDetail({super.key});

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
      body: const Center(
        child: Text('Notifications Page Content'),
      ),
    );
  }
}*/

