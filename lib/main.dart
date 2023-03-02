import 'package:flutter/material.dart';
import 'package:repit_app/login_page.dart';
import 'package:repit_app/style.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Style().textTheme(context),

      home: const LoginPage(),
    );
  }
}
