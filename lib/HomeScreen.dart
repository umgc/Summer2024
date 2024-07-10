import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mindinsync/Recording.dart';
import 'package:mindinsync/Search.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        backgroundColor: Colors.blue[300],
      ),
      body: ListView(
        children: [
          //MIND IN SYNC ICON
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/images/mind.jpg"))),
                  )
                ])
              ],
            ),
          ),

          // SizedBox(height: 20),
          // Image.network(
          //   'https://example.com/knowledge_base_icon.png', // Replace with your actual image URL or use AssetImage
          //   height: 100,
          // ),

          Container(
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    hintText: 'Search',
                  ),
                ),
              ],
            ),
          ),

          Container(
              padding: const EdgeInsets.only(top: 650),
              child: Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.mic, size: 50),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RecordScreen()));
                    },
                  )
                ],
              )),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              accountName: Text(
                "SMTL User",
                style: TextStyle(fontSize: 18),
              ),
              accountEmail: Text("user@test.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 165, 255, 137),
                child: Text(
                  "A",
                  style: TextStyle(fontSize: 30.0, color: Colors.blue),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text('Knowledge Base'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_upload),
              title: const Text('Upload file'),
              onTap: () {
                Navigator.pushNamed(context, '/document_upload');
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('LogOut'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        selectedItemColor: Colors.blueGrey,
        items: const [
          BottomNavigationBarItem(
              label: "Home",
              icon: (Icon(Icons.home)),
              activeIcon: Icon(Icons.home)),
          BottomNavigationBarItem(
            label: "Search",
            icon: (Icon(Icons.search)),
            activeIcon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
              label: "KnowledgeBase",
              icon: (Icon(Icons.library_books)),
              activeIcon: Icon(Icons.library_books)),
        ],
      ),
    );
  }
}
