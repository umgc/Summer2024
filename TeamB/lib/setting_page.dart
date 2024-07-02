import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Setting extends StatefulWidget
{
  final ValueNotifier<ThemeMode> themeModeNotifier;
  const Setting({super.key, required this.themeModeNotifier});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<Setting>
{
  ImageProvider _image = const AssetImage('assets/avatars/ducky.jpeg');

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async
  {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null)
    {
      setState(() {
        _image = FileImage(File(pickedFile.path));
      });
    }
  }

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
          CircleAvatar(
            backgroundImage: _image,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: widget.themeModeNotifier.value == ThemeMode.dark,
              onChanged: (bool value)
              {
                setState(()
                {
                  widget.themeModeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Change Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value)
              {
                setState(()
                {
                  _name = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: _image,
                  radius: 40,
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Change Photo'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
