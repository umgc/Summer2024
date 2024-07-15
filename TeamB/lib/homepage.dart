import 'package:flutter/material.dart';

void main() {
  runApp(IntelliGradeApp());
}

class IntelliGradeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IntelliGrade',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IntelliGrade Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'IntelliGrade Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.create),
              title: Text('Generate Exam'),
              onTap: () {
                // Navigate to Generate Exam screen
              },
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text('View Exams'),
              onTap: () {
                // Navigate to View Exams screen
              },
            ),
            ListTile(
              leading: Icon(Icons.grade),
              title: Text('Grading Suggestions'),
              onTap: () {
                // Navigate to Grading Suggestions screen
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Recent Exams',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ExamCard(
                    examTitle: 'Math 101 Midterm',
                    status: 'Graded',
                  ),
                  ExamCard(
                    examTitle: 'History 202 Final',
                    status: 'Pending',
                  ),
                  // Add more ExamCards as needed
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Recent Activity',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ActivityCard(
                    activity: 'Graded Math 101 Midterm',
                    timestamp: '2024-06-15 14:35',
                  ),
                  ActivityCard(
                    activity: 'Generated History 202 Final',
                    timestamp: '2024-06-14 10:22',
                  ),
                  // Add more ActivityCards as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExamCard extends StatelessWidget {
  final String examTitle;
  final String status;

  ExamCard({required this.examTitle, required this.status});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(examTitle),
        subtitle: Text('Status: $status'),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String activity;
  final String timestamp;

  ActivityCard({required this.activity, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(activity),
        subtitle: Text('Timestamp: $timestamp'),
      ),
    );
  }
}
