import 'package:flutter/material.dart';
import 'package:intelligrade/ui/drawer.dart';
import 'package:intelligrade/ui/header.dart';

class Search extends StatelessWidget
{
  const Search({super.key});

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: const AppHeader(),
      drawer: const AppDrawer(),
      body: const Center(
        child: Text('Search results here'),
      ),
    );
  }
}
