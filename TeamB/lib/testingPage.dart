import 'package:flutter/material.dart';

class TestingPage extends StatelessWidget {
  const TestingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
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
            backgroundImage: AssetImage('assets/avatars/ducky.jpeg'), // Your avatar image
          ),
        ],
      ),
      body: Row(
        children: [
          Container(
            width: 180,
            color: Colors.grey[400],
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Image(
                    image: AssetImage('assets/logos/icon512.png'),
                    height: 40,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.create),
                  title: Text('Dashboard'),
                  //onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.create),
                  title: Text('Create...'),
                  //onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.create),
                  title: Text('View Exams'),
                  //onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.create),
                  title: Text('Settings'),
                  //onTap: () {},
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double cardWidth = constraints.maxWidth * 0.9;

                    return Column(
                      children: [
                        SizedBox(
                          width: cardWidth,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Recent Exams',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  DataTable(
                                    columns: const [
                                      DataColumn(label: Text('TITLE')),
                                      DataColumn(label: Text('SUBJECT')),
                                      DataColumn(label: Text('STUDENTS')),
                                      DataColumn(label: Text('DATE CREATED')),
                                      DataColumn(label: Text('STATUS')),
                                      DataColumn(label: Text('ACTIONS')),
                                    ],
                                    rows: const [
                                      DataRow(cells: [
                                        DataCell(Text('Sample Title')),
                                        DataCell(Text('Math')),
                                        DataCell(Text('30')),
                                        DataCell(Text('2023-06-21')),
                                        DataCell(Text('Active')),
                                        DataCell(
                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: null,
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: cardWidth,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Recent Activity',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        child: const Text('See More'),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  DataTable(
                                    columns: const [
                                      DataColumn(label: Text('TITLE')),
                                      DataColumn(label: Text('SUBJECT')),
                                      DataColumn(label: Text('TIME')),
                                    ],
                                    rows: const [
                                      DataRow(cells: [
                                        DataCell(Text('Activity 1')),
                                        DataCell(Text('Subject 1')),
                                        DataCell(Text('10:00 AM')),
                                      ]),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testing Page'),
      ),
      body: Center(
        child: ElevatedButton(
          // Button to navigate to the Dashboard page
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Dashboard()),
            );
          },
          child: const Text('Go to Dashboard'),
        ),
      ),
    );
  }*/
//}
