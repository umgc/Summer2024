import 'package:flutter/material.dart';

void main() {
  runApp(ViewTestApp());
}

class ViewTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Quiz 1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MathQuizPage(),
    );
  }
}

class MathQuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe6f2ff),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            width: 1200,
            padding: EdgeInsets.all(20),
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
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color(0xffff6600),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                  child: Text(
                    'TestWizard',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                    textAlign: TextAlign.right,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xff0072bb),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
                  ),
                  child: Text(
                    'Math Quiz 1',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                SearchFilter(),
                SizedBox(height: 20),
                TableContainer(),
                SizedBox(height: 20),
                ButtonContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Search...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      onChanged: (value) {
        // Implement search functionality if needed
      },
    );
  }
}

class TableContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('Version')),
          DataColumn(label: Text('Student Name')),
          DataColumn(label: Text('Status')),
        ],
        rows: [
          DataRow(cells: [
            DataCell(Text('Version 1')),
            DataCell(Text('John Doe')),
            DataCell(Text('Completed')),
          ]),
          DataRow(cells: [
            DataCell(Text('Version 2')),
            DataCell(Text('Jane Doe')),
            DataCell(Text('In Progress')),
          ]),
          DataRow(cells: [
            DataCell(Text('Version 3')),
            DataCell(Text('John Smith')),
            DataCell(Text('Not Started')),
          ]),
          // Add more rows as needed
        ],
      ),
    );
  }
}

class ButtonContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff0072bb),
            foregroundColor: Colors.white,
          ),
          onPressed: () {},
          child: Text('Assign'),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff0072bb),
            foregroundColor: Colors.white,
          ),
          onPressed: () {},
          child: Text('Cancel'),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff0072bb),
            foregroundColor: Colors.white,
          ),
          onPressed: () {},
          child: Text('Save'),
        ),
      ],
    );
  }
}
