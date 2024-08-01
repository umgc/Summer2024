import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
const Homepage({super.key});

@override
HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
@override
Widget build(BuildContext context) {
return Scaffold(
  appBar: AppBar(
    title: const Text("New Home Page"),
  ),
  body: const Center(
    child: Text("Hello New Page",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),),
  ),
);
}
}
