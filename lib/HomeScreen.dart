import 'package:flutter/material.dart';
import 'package:mindinsync/Recording.dart';
import 'package:mindinsync/Search.dart';
import 'package:mindinsync/document_upload.dart';
import 'package:mindinsync/Edit_Profile.dart';
import 'package:mindinsync/prompt.dart';
import 'package:permission_handler/permission_handler.dart';
import 'BottomNavigation.dart';
import 'Drawer.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var _controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        backgroundColor: Colors.blue[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // MIND IN SYNC ICON
            Container(
              alignment: Alignment.topRight,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/mind.jpg"),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Search Field
            TextField(
                controller: _controller,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  hintText: 'Ask a question to MindAI',
                  suffixIcon: IconButton(
                      icon: const Icon(Icons.mic),
                      onPressed: () {
                        _controller.clear();
                        Navigator.pushNamed(
                          context,
                          '/Prompt',
                          arguments: "supersecretaudiostartnobodygoingtofigureout",
                        );
                      }),
                ),
                onSubmitted: (String value) async {
                  _controller.clear();
                  Navigator.pushNamed(
                    context,
                    '/Prompt',
                    arguments: value,
                  );
                }),
            const SizedBox(height: 20),
            // Grid Layout for Icons
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildGridItem(
                    context,
                    icon: Icons.mic,
                    label: 'Record',
                    destination: const RecordScreen(),
                  ),
                  _buildGridItem(
                    context,
                    icon: Icons.folder,
                    label: 'Documents',
                    destination: const DocumentUpload(),
                  ),
                  _buildGridItem(
                    context,
                    icon: Icons.search,
                    label: 'Search',
                    destination: const Search(),
                  ),
                  _buildGridItem(
                    context,
                    icon: Icons.settings,
                    label: 'Settings',
                    destination: const EditProfileScreen(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: const DrawerMenu(),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0, // Set the current index for the Home screen
        onTap: (index) {
          switch (index) {
            case 0:
              // Navigate to Home screen (optional)
              break;
            case 1:
              Navigator.pushNamed(context, '/Search');
              break;
            case 2:
              Navigator.pushNamed(context, '/knowledge_base');
              break;
            default:
              break;
          }
        },
      ),
    );
  }

  Widget _buildGridItem(BuildContext context,
      {required IconData icon,
      required String label,
      required Widget destination}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue[100],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.blue[900]),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
