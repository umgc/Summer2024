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
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          shrinkWrap: true,
          children: [
            const Center(
              child: Text(
                'Quick actions',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildExpansionTile(
              'Edit Questions on Generated Assignments',
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(' Placeholder',),
                  SizedBox(height: 8, width: 8),
                  Text('1. Placeholder'),
                  Text('2. Placeholder'),
                  Text(
                    'Placeholder',
                  ),
                  Text(
                    'Placeholder',
                  ),
                ],
              ),
            ),
            _buildExpansionTile(
              'Edit generated Rubric',
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(' Placeholder',),
                  SizedBox(height: 8, width: 8),
                  Text('1. Placeholder'),
                  Text('2. Placeholder'),
                  Text(
                    'Placeholder',
                  ),
                  Text(
                    'Placeholder',
                  ),
                ],
              ),
            ),
            _buildExpansionTile(
              'How do I create an Assignment?',
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(' Placeholder',),
                  SizedBox(height: 8, width: 8),
                  Text('1. Placeholder'),
                  Text('2. Placeholder'),
                  Text(
                    'Placeholder',
                  ),
                  Text(
                    'Placeholder',
                  ),
                ],
              ),
            ),
            _buildExpansionTile(
              'I want to regain access to my suspended account.',
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(' Placeholder',),
                  SizedBox(height: 8, width: 8),
                  Text('1. Placeholder'),
                  Text('2. Placeholder'),
                  Text(
                    'Placeholder',
                  ),
                  Text(
                    'Placeholder',
                  ),
                ],
              ),
            ),
            _buildExpansionTile(
              'Blank Question',
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(' Placeholder',),
                  SizedBox(height: 8, width: 8),
                  Text('1. Placeholder'),
                  Text('2. Placeholder'),
                  Text(
                    'Placeholder',
                  ),
                  Text(
                    'Placeholder',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildExpansionTile(String title, Widget content) {
    return ExpansionTile(
      title: Text(title),
      children: [Padding(padding: const EdgeInsets.all(16.0), child: content)],
    );
  }
}
