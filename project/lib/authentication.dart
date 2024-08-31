import 'package:flutter/material.dart';
import 'package:project/home.dart';  // Import HomePage for navigation

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String _email = '';
  String _password = '';
  bool _isLogin = true;

  void _submitAuthForm() {
    if (_email.isNotEmpty && _password.isNotEmpty) {
      // Simple local validation or mock authentication
      if (_isLogin) {
        // Perform login actions
        print('User signed in with email: $_email');
      } else {
        // Perform sign up actions
        print('User signed up with email: $_email');
      }
      // Navigate to home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      // Show an error message
      print('Please enter valid email and password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove the background color setting here
      appBar: null,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // App name centered above the email field
              Text(
                'Omni Navigator',
                style: TextStyle(
                  fontSize: 24,  // Adjust font size as needed
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),  // Space between app name and email field
              TextField(
                key: ValueKey('email'),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email'),
                onChanged: (value) {
                  _email = value;
                },
              ),
              TextField(
                key: ValueKey('password'),
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                onChanged: (value) {
                  _password = value;
                },
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: _submitAuthForm,
                child: Text(_isLogin ? 'Sign In' : 'Sign Up'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                child: Text(_isLogin ? 'Create new account' : 'I already have an account'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
