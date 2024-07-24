import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mindinsync/StorageService.dart';
import 'package:mindinsync/db_helper.dart';
import 'package:mindinsync/LoginPage.dart';
import 'package:mindinsync/Disclaimer.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Row(
              //   children: [
              //     InkWell(
              //       onTap: () {
              //         // Call your function here
              //         _authenticate();
              //       },
              //       child: Text("Use Biometric Authentication"),
              //     )
              //   ],
              // ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    // primary: Colors.green,
                    ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    SharedPreferences sp =
                        await SharedPreferences.getInstance();
                    sp.setString('userEmail', _emailController.text);
                    print(sp.getString('userEmail'));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DisclaimerPage(submitForm: _submitForm),
                      ),
                    );
                  }
                },
                child: const Text('Create Account'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    // primary: Colors.black,
                    // onPrimary: Colors.white,
                    ),
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

  Future<void> _submitForm() async {
    String firstname = _firstNameController.text;
    String lastname = _lastNameController.text;
    String email = _emailController.text;
    
    StorageService tran_store = new StorageService();
    tran_store.deleteTable();
    // Save the user's email using SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);

    DBHelper db = new DBHelper();
    await db.insertUser(firstname, lastname, email);
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
  }
}
