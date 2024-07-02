import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget
{
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Login"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: ()
              {
                Navigator.pushNamed(context, '/dashboard');
              },
              child: const Text('Go to the dashboard Page'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: ()
              {
                Navigator.pushNamed(context, '/search');
              },
              child: const Text('Go to the Search Page'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: ()
              {
                Navigator.pushNamed(context, '/Testsettings');
              },
              child: const Text('Go to the Test Page'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: ()
              {
                Navigator.pushNamed(context, '/help');
              },
              child: const Text('Go to the Help Page'),
            ),
          ],
        ),
      ),
    );
  }
}
