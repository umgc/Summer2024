import 'package:flutter/material.dart';
import 'package:mindinsync/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';

var userID; // global variable for userID

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  String email = emailController.text;

  late Future<String> _userIdFuture; // Future for fetching userID

  @override
  void initState() {
    super.initState();
    _userIdFuture = getUserId(email); // Initialize the Future in initState
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset the Future when dependencies change (e.g., email changes)
    _userIdFuture = getUserId(email);

    // Update userID when _userIdFuture completes
    _userIdFuture.then((userId) {
      setState(() {
        userID = userId; // Assign the fetched userID to the global variable
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
                return buildDrawerHeader('Loading...', 'A', Colors.green);
              } else if (snapshot.hasError) {
                return buildDrawerHeader('Error', 'A', Colors.green);
              } else {
                return buildDrawerHeader(
                    snapshot.data ?? 'User',
                    snapshot.data != null && snapshot.data!.isNotEmpty
                        ? snapshot.data!.substring(0, 1)
                        : 'A',
                    Colors.green);
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
              print(userID);
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

  UserAccountsDrawerHeader buildDrawerHeader(
      String accountName, String avatarText, Color backgroundColor) {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      accountName: Text(
        accountName,
        style: TextStyle(fontSize: 18),
      ),
      accountEmail: Text(
        email,
        style: TextStyle(fontSize: 18),
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Color.fromARGB(255, 165, 255, 137),
        child: Text(
          avatarText,
          style: TextStyle(fontSize: 30.0, color: Colors.blue),
        ),
      ),
    );
  }

  DBHelper db = DBHelper();

  Future<String> getUserName(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString("user_name");
    if(userName == null){
    userName = await db.getUserName(email);
    }
    prefs.setString("user_name",userName);
    return userName;
  }

  Future<String> getUserId(String email) async {
    String userId = await db.getUserId(email);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user_id",userId);
    return userId;
  }
  
}
