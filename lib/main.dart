import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PreschoolApp());
}

class PreschoolApp extends StatelessWidget {
  const PreschoolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}