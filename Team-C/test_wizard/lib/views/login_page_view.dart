import 'package:flutter/material.dart';
import 'package:test_wizard/views/teacher_dashboard_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe6f2ff),
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(20),
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
                color: const Color(0xffff6600),
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'TestWizard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              Container(
                color: const Color(0xff0072bb),
                padding: const EdgeInsets.all(20),
                child: const Text(
                  'Login to TestWizard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'lib/assets/wizard2.png', // Ensure this path is correct
                width: 200,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Your OAuth login logic here
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      // to Teacher Dashboard with 'logged in' status for now
                      builder: (context) => const TeacherDashboard(
                        status: 'logged in',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0072bb),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('Login with Moodle'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  //Guest Login here
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      // to Teacher Dashboard with no info for now
                      builder: (context) => const TeacherDashboard(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffff6600),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('Login as Guest'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
