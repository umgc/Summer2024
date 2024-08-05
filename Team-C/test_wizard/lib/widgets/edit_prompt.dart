import 'package:flutter/material.dart';

class EditPrompt extends StatelessWidget {
  const EditPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xff0072bb),
          ),
          onPressed: () {},
          child: const Text('Edit Prompt (Advanced)'),
        ),
      ),
    );
  }
}
