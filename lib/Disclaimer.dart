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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                'Please read and agree to the terms and conditions to proceed. \n \nPlease be aware that biometric login features, including fingerprint and facial recognition, are designed to enhance security and convenience. However, no system is completely infallible, and the accuracy of biometric authentication can be affected by various factors such as environmental conditions, hardware limitations, or changes in your physical characteristics. By using biometric login, you acknowledge that while these methods are intended to provide a higher level of security, they are not immune to errors or potential security breaches. For your safety, it is advisable to use biometric authentication in conjunction with other security measures, such as strong passwords or multi-factor authentication, where applicable.',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16),
              ),
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
