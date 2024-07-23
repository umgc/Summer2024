import 'package:flutter/material.dart';
import 'package:intelligrade/ui/drawer.dart';
import 'package:intelligrade/ui/header.dart';

class Help extends StatelessWidget
{
  const Help({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: const AppHeader(),
      drawer: const AppDrawer(),
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
