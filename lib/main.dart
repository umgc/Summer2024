import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mindinsync/HomeScreen.dart';
import 'package:mindinsync/navigation.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  final String appTitle = 'Flutter Drawer Demo';

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: const Home()
    );
  }
}