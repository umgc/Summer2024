import 'package:flutter/material.dart';
import 'package:mindinsync/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'registerPage.dart';
import 'package:mindinsync/db_helper.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  String email = '';
  Future<String> _getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail') ?? '';

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // setState(() {
    //   userEmail = prefs.getString('userEmail');
    //   emailController.text = userEmail ?? '';
    // });
  }

  @override
  void initState() {
    super.initState();
    _getUserEmail().then((value) {
      setState(() {
        email = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder<String>(
            future: getUserName(email),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.green,
                  ),
                  accountName: Text(
                    'Loading...',
                    style: TextStyle(fontSize: 18),
                  ),
                  accountEmail: Text(
                    email,
                    style: TextStyle(fontSize: 18),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 165, 255, 137),
                    child: Text(
                      "A",
                      style: TextStyle(fontSize: 30.0, color: Colors.blue),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.green,
                  ),
                  accountName: Text(
                    'Error',
                    style: TextStyle(fontSize: 18),
                  ),
                  accountEmail: Text(
                    email,
                    style: TextStyle(fontSize: 18),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 165, 255, 137),
                    child: Text(
                      "A",
                      style: TextStyle(fontSize: 30.0, color: Colors.blue),
                    ),
                  ),
                );
              } else {
                return UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.green,
                  ),
                  accountName: Text(
                    snapshot.data ?? "User",
                    style: TextStyle(fontSize: 18),
                  ),
                  accountEmail: Text(
                    email,
                    style: TextStyle(fontSize: 18),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 165, 255, 137),
                    child: Text(
                      "A",
                      style: TextStyle(fontSize: 30.0, color: Colors.blue),
                    ),
                  ),
                );
              }
            },
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
            leading: const Icon(Icons.edit),
            title: const Text('Edit Profile'),
            onTap: () {
              Navigator.pushNamed(context, '/edit_profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('LogOut'),
            onTap: () {
              Navigator.pushNamed(context, '/register');
            },
          ),
        ],
      ),
    );
  }

  Future<String> getUserName(String email) async {
    DBHelper db = DBHelper();
    String userName = await db.getUserName(email);
    return userName;
  }
}
