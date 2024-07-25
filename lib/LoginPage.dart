import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mindinsync/StorageService.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool _isButtonActive = false;
TextEditingController emailController = TextEditingController();

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? userEmail;

  late final LocalAuthentication auth;
  bool _supportState = false;
  final _formKey = GlobalKey<FormState>(); // Add a global key for the Form

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() {
            _supportState = isSupported;
          }),
        );
  }

  Future<void> _loadUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('userEmail');
      print(userEmail);
      emailController.text = userEmail ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('MindInSync'),
        backgroundColor: Colors.blue[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey, // Assign the global key to the Form
          onChanged: () {
            setState(() {
              _isButtonActive = emailController.text.isNotEmpty;
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email Address'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      // Call your function here
                      _authenticate();
                    },
                    child: Text("Use Biometric Authentication"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to access your account',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      print("Authenticated: $authenticated");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userEmail = prefs.getString('userEmail');
      if (userEmail == null) {
        prefs.setString('userEmail', emailController.text);
      }
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
