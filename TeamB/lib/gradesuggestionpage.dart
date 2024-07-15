import 'package:flutter/material.dart';

class GradeSuggestionPage extends StatelessWidget {
  const GradeSuggestionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample data
    final List<Map<String, dynamic>> gradeSuggestions = [
      {
        'studentName': 'John Doe',
        'examDetails': 'Midterm Exam',
        'suggestedGrade': 'A',
        'questions': [
          {'question': 'Question 1', 'suggestedGrade': 'A'},
          {'question': 'Question 2', 'suggestedGrade': 'B+'},
          // Add more questions if needed
        ],
      },
      {
        'studentName': 'Jane Smith',
        'examDetails': 'Midterm Exam',
        'suggestedGrade': 'B+',
        'questions': [
          {'question': 'Question 1', 'suggestedGrade': 'B'},
          {'question': 'Question 2', 'suggestedGrade': 'A'},
          // Add more questions if needed
        ],
      },
      // Add more students if needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grade Suggestion Page'),
      ),
      body: ListView.builder(
        itemCount: gradeSuggestions.length,
        itemBuilder: (context, index) {
          final suggestion = gradeSuggestions[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Student: ${suggestion['studentName']}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Exam: ${suggestion['examDetails']}'),
                  const SizedBox(height: 8.0),
                  ...suggestion['questions'].map<Widget>((question) {
                    return ListTile(
                      title: Text(question['question']),
                      subtitle: Text('Suggested Grade: ${question['suggestedGrade']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Handle edit action here
                        },
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 8.0),
                  Text(
                    'Suggested Grade: ${suggestion['suggestedGrade']}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Handle approve all action here
                        },
                        child: const Text('Approve All'),
                      ),
                      const SizedBox(width: 8.0),
                      ElevatedButton(
                        onPressed: () {
                          // Handle submit action here
                        },
                        child: const Text('Submit'),
                      ),
                    ],
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
