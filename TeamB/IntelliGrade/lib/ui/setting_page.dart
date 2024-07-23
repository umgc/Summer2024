import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intelligrade/ui/drawer.dart';
import 'dart:io';

import 'package:intelligrade/ui/header.dart';

class Setting extends StatefulWidget
{
  final ValueNotifier<ThemeMode> themeModeNotifier;
  const Setting({super.key, required this.themeModeNotifier});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<Setting>
{
  ImageProvider _image = const AssetImage('avatars/ducky.jpeg');
  String _name = "User";
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
      appBar: const AppHeader(),
      drawer: const AppDrawer(),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: ()
                  {
                    // Handle form submission
                  },
                  child: const Text('Change'),
                ),
              ],
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
