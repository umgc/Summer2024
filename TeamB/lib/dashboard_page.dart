import 'package:flutter/material.dart';



class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double cardWidth = constraints.maxWidth * 0.9;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8968CD),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: cardWidth,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Recent Exams:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: () {},
                                child: const Text('See More'),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {},
                                child: const Text('Import'),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text('Export'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: cardWidth,
                              ),
                              child: DataTable(
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: cardWidth,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Recent Activity:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: () {},
                                child: const Text('See More'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: cardWidth,
                              ),
                              child: DataTable(
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
                            ),
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
    );
  }
}
