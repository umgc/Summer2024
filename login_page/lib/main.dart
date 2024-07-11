import 'package:flutter/material.dart';

void main() {
  runApp(LoginPageApp());
}

class LoginPageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe6f2ff),
      body: Center(
        child: Container(
          width: 400,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Color(0xffff6600),
                padding: EdgeInsets.all(10),
                child: Text(
                  'TestWizard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              Container(
                color: Color(0xff0072bb),
                padding: EdgeInsets.all(20),
                child: Text(
                  'Login to TestWizard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Image.asset(
                'assets/wizard2.png', // Ensure this path is correct
                width: 200,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Your OAuth login logic here
                },
                child: Text('Login with Moodle'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff0072bb),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
