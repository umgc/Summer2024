import 'package:flutter/material.dart';

void main() => runApp(IntelliGradeApp());

class IntelliGradeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IntelliGrade',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SearchResultPage(),
    );
  }
}

class SearchResultPage extends StatelessWidget {
  final List<SearchResult> results = [
    SearchResult(
      title: 'Exam 1',
      description: 'Exam on Introduction to Programming',
      date: '2024-06-01',
    ),
    SearchResult(
      title: 'Exam 2',
      description: 'Exam on Advanced Databases',
      date: '2024-06-10',
    ),
    SearchResult(
      title: 'Exam 3',
      description: 'Exam on Software Engineering',
      date: '2024-06-15',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          return SearchResultTile(result: results[index]);
        },
      ),
    );
  }
}

class SearchResult {
  final String title;
  final String description;
  final String date;

  SearchResult({required this.title, required this.description, required this.date});
}

class SearchResultTile extends StatelessWidget {
  final SearchResult result;

  SearchResultTile({required this.result});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(result.title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(result.description),
          SizedBox(height: 5),
          Text(result.date, style: TextStyle(color: Colors.grey)),
        ],
      ),
      onTap: () {
        // Implement navigation to exam details
      },
    );
  }
}
