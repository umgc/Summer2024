import 'package:flutter/material.dart';
import 'package:intelligrade/ui/drawer.dart';
import 'package:intelligrade/ui/header.dart';

class Testing extends StatelessWidget {
  const Testing({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppHeader(),
      drawer: AppDrawer(),
      body: Center(
        child: Text('Notifications Page Content'),
      ),
    );
  }
}