import 'package:flutter/material.dart';

class Help extends StatelessWidget
{
  const Help({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IntelliGrade'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: ()
            {
              Navigator.pushNamed(context, '/search');
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: ()
            {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: ()
            {
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
              onTap: ()
              {
                Navigator.pushNamed(context, '/dashboard');
              },
            ),
            ListTile(
              leading: const Icon(Icons.create),
              title: const Text('Create...'),
              onTap: ()
              {
                Navigator.pushNamed(context, '/create');
              },
            ),
            ListTile(
              leading: const Icon(Icons.view_list),
              title: const Text('View Exams'),
              onTap: ()
              {
                Navigator.pushNamed(context, '/viewExams');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: ()
              {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Help Page Content'),
      ),
    );
  }
}
