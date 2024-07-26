import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mindinsync/db_helper.dart';
import 'package:mindinsync/LoginPage.dart';
import 'package:mindinsync/Disclaimer.dart';

bool _isButtonActive = false;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  late final LocalAuthentication auth;
  bool _supportState = false;
  final _formKey = GlobalKey<FormState>(); // Add a global key for the Form
  Future<bool>? _emailExistsFuture;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() {
            _supportState = isSupported;
          }),
        );
  }

  Future<bool> _checkEmail(String email) async {
    DBHelper db = DBHelper();
    return await db.checkEmail(email);
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
          key: _formKey, // Assign a global key to the Form
          onChanged: () {
            setState(() {
              _isButtonActive = _firstNameController.text.isNotEmpty &&
                  _lastNameController.text.isNotEmpty &&
                  _emailController.text.isNotEmpty;
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onChanged: (value) {
                  // Check if the email exists whenever the text changes
                  setState(() {
                    _emailExistsFuture = _checkEmail(value);
                  });
                },
                // Using a FutureBuilder to show the error based on the async email check
                // The email error will be set in the FutureBuilder
                // But we need to show the error in the TextFormField itself
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isButtonActive ? _register : null,
                child: const Text('Create Account'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Login'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      String firstname = _firstNameController.text.replaceAll(" ", "_");
      String lastname = _lastNameController.text;
      String email = _emailController.text;

      // Check if email exists
      bool emailExists = await _checkEmail(email);
      if (emailExists) {
        // Show email already exists error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email address already exists.')),
        );
      } else {
        // Save the user's email using SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userEmail', email);

        // Insert user into the database
        DBHelper db = DBHelper();
        await db.insertUser(firstname, lastname, email);

        // Clear the form fields
        //_firstNameController.clear();
        // _lastNameController.clear();
        //_emailController.clear();

        // Navigate to the disclaimer page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisclaimerPage(submitForm: _submitForm),
          ),
        );
      }
    }
  }

  Future<void> _submitForm() async {
    String firstname = _firstNameController.text.replaceAll(" ", "_");
    String lastname = _lastNameController.text;
    String email = _emailController.text;

    // Save the user's email using SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);

    DBHelper db = DBHelper();
    await db.insertUser(firstname, lastname, email);

    // Clear the form fields
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
  }
}
