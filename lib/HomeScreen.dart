import 'package:flutter/material.dart';
import 'package:mindinsync/Recording.dart';

class Home extends StatelessWidget {
  const Home({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       
        backgroundColor: Colors.green,
      ),
      body:Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            

       
            SizedBox(height: 20),
            // Image.network(
            //   'https://example.com/knowledge_base_icon.png', // Replace with your actual image URL or use AssetImage
            //   height: 100,
            // ),
            SizedBox(height: 20),
            const Text(
              'Home',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                hintText: 'Search',
              ),
            ),
    

            Container(
                height: 450,
                alignment: Alignment.bottomCenter,
                child:
                 
                IconButton(
                  
                  icon: const Icon(Icons.mic, size: 50),  
                  onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RecordScreen()));  
                   },
                  )
              
                
              
          )
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
              leading: Icon(Icons.library_books),
              title: Text('Knowledge Base'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.file_upload),
              title: Text('Upload file to Database'),
              onTap: () {
                Navigator.pop(context);
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
    bottomNavigationBar: BottomNavigationBar (

  items: const [
     BottomNavigationBarItem(label: "Home", icon: (Icon(Icons.home)),  activeIcon: Icon(Icons.home)),
     BottomNavigationBarItem(label: "Search", icon: (Icon(Icons.search)), activeIcon: Icon(Icons.search)), 
     BottomNavigationBarItem(label: "KnowledgeBase",  icon: (Icon(Icons.library_books)), activeIcon: Icon(Icons.library_books)) , 
  ], 
), 
   
   
   
    );


  }
}

