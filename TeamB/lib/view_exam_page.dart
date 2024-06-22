import 'package:flutter/material.dart';

class ViewExamPage extends StatelessWidget {
  const ViewExamPage({Key? key}) : super(key: key);

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
            backgroundImage: AssetImage('assets/avatars/ducky.jpeg'), // Your avatar image
          ),
        ],
      ),
      body: Row(
        children: [
          Container(
            width: 180,
            color: Colors.grey[400],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
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
                    Navigator.pushNamed(context, '/create'); // Ensure this route is defined if you use it
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.view_list),
                  title: const Text('View Exams'),
                  onTap: () {
                    Navigator.pushNamed(context, '/viewExams'); // Ensure this route is defined if you use it
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pushNamed(context, '/settings'); // Ensure this route is defined if you use it
                  },
                ),
              ],
            ),
          ),
          // Add your other widgets for the main content of the page here.
        ],
      ),
    );
  }
}
