import 'package:flutter/material.dart';
import 'package:project/authentication.dart';  // Import AuthScreen for starting the app

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Domain Selector',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthScreen(),  // Start with the authentication screen
    );
  }
}


