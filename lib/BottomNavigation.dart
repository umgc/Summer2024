// import 'package:flutter/material.dart';
// import 'package:mindinsync/Recording.dart';
// import 'package:mindinsync/Search.dart';
// import 'package:mindinsync/document_upload.dart';
// import 'package:mindinsync/Edit_Profile.dart';
// import 'package:mindinsync/HomeScreen.dart';

// class BottomNavBar extends StatelessWidget {
//   final int currentIndex;

//   const BottomNavBar({super.key, required this.currentIndex});

//   void _onItemTapped(BuildContext context, int index) {
//     switch (index) {
//       case 0:
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const Home()),
//         );
//         break;
//       case 1:
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const Search()),
//         );
//         break;
//       case 2:
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const DocumentUpload()),
//         );
//         break;
//       case 3:
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const EditProfileScreen()),
//         );
//         break;
//       case 4:
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const RecordScreen()),
//         );
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       currentIndex: currentIndex,
//       onTap: (index) => _onItemTapped(context, index),
//       selectedItemColor: Colors.blueGrey,
//       items: const [
//         BottomNavigationBarItem(
//           label: "Home",
//           icon: Icon(Icons.home),
//           activeIcon: Icon(Icons.home),
//         ),
//         BottomNavigationBarItem(
//           label: "Search",
//           icon: Icon(Icons.search),
//           activeIcon: Icon(Icons.search),
//         ),
//         BottomNavigationBarItem(
//           label: "Documents",
//           icon: Icon(Icons.folder),
//           activeIcon: Icon(Icons.folder),
//         ),
//         BottomNavigationBarItem(
//           label: "Settings",
//           icon: Icon(Icons.settings),
//           activeIcon: Icon(Icons.settings),
//         ),
//         BottomNavigationBarItem(
//           label: "Record",
//           icon: Icon(Icons.mic),
//           activeIcon: Icon(Icons.mic),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      elevation: 10,
      selectedItemColor: Colors.blueGrey,
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          label: "Home",
          icon: Icon(Icons.home),
          activeIcon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: "Search",
          icon: Icon(Icons.search),
          activeIcon: Icon(Icons.search),
        ),
        BottomNavigationBarItem(
          label: "KnowledgeBase",
          icon: Icon(Icons.library_books),
          activeIcon: Icon(Icons.library_books),
        ),
      ],
    );
  }
}
