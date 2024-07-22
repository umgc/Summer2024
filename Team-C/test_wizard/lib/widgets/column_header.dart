// lib/widgets/column_header.dart
import 'package:flutter/material.dart';

class ColumnHeader extends StatelessWidget {
  final String headerText;

  const ColumnHeader({super.key, required this.headerText});

  @override
  Widget build(BuildContext context) {
    return Text(
      headerText,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
