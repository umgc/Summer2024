import 'dart:ffi';
import 'package:mindinsync/registerPage.dart';
import 'package:flutter/material.dart';

class DisclaimerPage extends StatelessWidget {
  final VoidCallback submitForm;

  DisclaimerPage({required this.submitForm});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disclaimer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please read and agree to the terms and conditions to proceed.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc auctor tincidunt ligula. Maecenas at rutrum sapien. Sed a neque id dui imperdiet accumsan. Nam et vulputate massa. Sed pellentesque pretium sagittis. ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                submitForm();
                // Navigate to login page
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('Agree'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Go back to the previous page
                Navigator.pop(context);
              },
              child: Text('Disagree'),
            ),
          ],
        ),
      ),
    );
  }
}
