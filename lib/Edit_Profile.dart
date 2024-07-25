import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindinsync/db_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'BottomNavigation.dart';
import 'Drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _profileImage;
  String? userEmail;
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
    _loadUserName();
    // Load existing profile data here if available
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });

      // Save the picked image to the application's document directory
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'profile_image.png';
      final savedImage = await _profileImage!.copy('${appDir.path}/$fileName');

      // Optionally, save the image path to the user's profile data
    }
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString('userEmail');
    userName = await getUserName(userEmail!);
   // print("test");
    setState(() {         
      _nameController.text = userName ?? '';
    });
  }

  Future<String> getUserName(String email) async {
    DBHelper db = DBHelper();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString("user_name");
    if(userName == null){
    userName = await db.getUserName(email);
    }
    prefs.setString("user_name",userName);
    return userName;
  }

  Future<void> _loadUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString('userEmail');
    print(userEmail);
   // print("test");
    setState(() {         
      _emailController.text = userEmail ?? '';
    });
  }

  Future<void> _saveProfile() async {
    // Save the user's name and email
    final name = _nameController.text.replaceAll(" ","_");
    final email = _emailController.text;

    // Optionally, save the profile data to persistent storage
    // For example, using SharedPreferences, SQLite, or any other storage solution

    // Show a success message or navigate to another screen
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Profile saved successfully!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.blue[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? Icon(Icons.camera_alt, size: 50, color: Colors.white)
                    : null,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Save Profile'),
            ),
            ElevatedButton(
            onPressed: () {Navigator.pushNamed(context, '/Register');},
            child: const Text('Register your voice with the Transcriber'),
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
              Navigator.pushNamed(context, '/home');
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
}

void main() {
  runApp(MaterialApp(
    home: EditProfileScreen(),
  ));
}
