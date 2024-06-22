import 'package:flutter/material.dart';



class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width:200,
            color: Colors.grey[400],
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Image(image: AssetImage('assets/logos/icon512.png',),height:  40),
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
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 60,
                  color: Colors.white,
                  child: Row (
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     const Text('Dashboard', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                     Row(
                       children: [
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
                   ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Recent Exams', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

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
                                      // I created a example, so you can see how the data would populate.
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
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Recent Exams', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                                  const SizedBox(height: 20),
                                  DataTable(
                                    columns: const [
                                      DataColumn(label: Text('TITLE')),
                                      DataColumn(label: Text('SUBJECT')),
                                      DataColumn(label: Text('TIME')),
                                    ],
                                    rows: const [
                                      // I created a example, so you can see how the data would populate.
                                      DataRow(cells: [
                                        DataCell(Text('Sample Title 1')),
                                        DataCell(Text('BIOLOGY')),
                                        DataCell(Text(' 2 hours ago')),
                                      ]),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
