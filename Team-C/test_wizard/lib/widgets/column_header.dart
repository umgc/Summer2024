import 'package:flutter/material.dart';

class ColumnHeader extends StatelessWidget {
  final String headerText;
  const ColumnHeader({super.key, required this.headerText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xff0072bb),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        headerText,
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}
