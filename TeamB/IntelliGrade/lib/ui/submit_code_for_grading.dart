import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SubmitCodeScreen(),
    );
  }
}

class SubmitCodeScreen extends StatefulWidget {
  @override
  _SubmitCodeScreenState createState() => _SubmitCodeScreenState();
}

class _SubmitCodeScreenState extends State<SubmitCodeScreen> {
  final TextEditingController _codeController = TextEditingController();
  String? _selectedExam;
  String _statusMessage = '';

  final List<String> _exams = [
    'Exam 1',
    'Exam 2',
    'Exam 3'
  ]; // Example exam list

  void _submitCode() {
    if (_selectedExam == null || _codeController.text.isEmpty) {
      setState(() {
        _statusMessage = 'Please select an exam and enter your code.';
      });
      return;
    }
    // Simulate submission process
    setState(() {
      _statusMessage = 'Code submitted successfully for grading!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Code for Grading'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Exam',
                border: OutlineInputBorder(),
              ),
              value: _selectedExam,
              items: _exams.map((exam) {
                return DropdownMenuItem<String>(
                  value: exam,
                  child: Text(exam),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedExam = value;
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: 'Enter Your Code',
                border: OutlineInputBorder(),
              ),
              maxLines: 10,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitCode,
              child: Text('Submit Code'),
            ),
            SizedBox(height: 20),
            Text(
              _statusMessage,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
