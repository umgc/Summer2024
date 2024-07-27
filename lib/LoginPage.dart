import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mindinsync/db_helper.dart';

bool _isButtonActive = false;
TextEditingController emailController = TextEditingController();

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? userEmail;
  bool _emailExists = false;
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
      emailController.text = userEmail ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: const Text('MindInSync'),
      //   centerTitle: true,
        
      //   backgroundColor: Colors.white,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
                'MindInSYNC',
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 55, 139, 223),
                ),
              ),
              const SizedBox(height: 10),
              Image.asset(
                'assets/images/mind.jpg', 
                height: 150,
              ),
              const SizedBox(height: 16),
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null; // No error
                },
              ),
              //const SizedBox(height: 16),
              //Row(
              //  children: [
              //  InkWell(
              //    onTap: () {
              //    _authenticate();
              //  },
              // child: Text("Use Biometric Authentication"),
              //)
              // ],
              // ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isButtonActive ? _login : null,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Check if email exists before proceeding with authentication
      _emailExists = await _checkEmail();

      if (_emailExists) {
        // Perform biometric authentication
        bool authenticated = await _authenticate();
        if (authenticated) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userEmail', emailController.text);
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Authentication failed.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email address does not exist.')),
        );
      }
    }
  }

  Future<bool> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to access your account',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      print("Authenticated: $authenticated");
      return authenticated;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> _checkEmail() async {
    DBHelper db = DBHelper();
    return await db.checkEmail(emailController.text);
  }
}
