import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';



void main() => runApp(const MyApp(title: '',));


 class MyApp extends StatelessWidget {
  final appTitle = 'Flutter Drawer Demo';
 
  const MyApp({Key? key, required String title}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: HomeScreen(title: appTitle),
    ); // MaterialApp
  }
}


class HomeScreen extends StatelessWidget {
  final String title;
 const HomeScreen({Key? key, required this.title}) : super(key: key);
  
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green,
      ),
      

      body:
      Container(        
        alignment:Alignment.bottomCenter,
        child:IconButton(icon: Icon(Icons.mic), onPressed: () {}, iconSize: 50 )),//Button Container Add information in the onPressed method to make it do work. 
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
                
              ), //BoxDecoration
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.green),
                accountName: Text(
                  "SMTL User",
                  style: TextStyle(fontSize: 18),
                ),
                accountEmail: Text("user@test.com"),//
                currentAccountPictureSize: Size.square(50),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 165, 255, 137),
                  child: Text(
                    "A",
                    style: TextStyle(fontSize: 30.0, color: Colors.blue),
                  ), //Text
                ), //circleAvatar
              ), //UserAccountDrawerHeader
            ), //DrawerHeader
            ListTile(
              leading: const Icon(Icons.library_books),
              title: const Text(' Knowledge Base'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_upload),
              title: const Text('Upload file to Database'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          
      
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text(' Edit Profile '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('LogOut'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ), //Drawer
   
    );


    
  }
 
 







