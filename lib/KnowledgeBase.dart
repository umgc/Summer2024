// Placeholder file
import 'package:flutter/material.dart';

class KnowledgeBase extends StatelessWidget {
  const KnowledgeBase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Knowledge Base'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Knowledge Base',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                hintText: 'Search',
              ),
            ),
            const SizedBox(height: 20),
            IconButton(
              icon: const Icon(Icons.help_outline, size: 60),
              onPressed: () {
                // Handle ask button press
              },
            ),
            const SizedBox(height: 20),
            IconButton(
              icon: const Icon(Icons.mic),
              onPressed: () {
                // Handle mic button press
              },
              iconSize: 50,
            ),
          ],
        ),
      ),
    );
  }
}