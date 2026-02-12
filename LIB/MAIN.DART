import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(SSMSoftware());
}

class SSMSoftware extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SSM SOFTWARE',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
    );
  }
}
