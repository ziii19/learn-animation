import 'package:flutter/material.dart';
import 'package:learn_animate/learn/learn1.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blue[900],
      ),
      home: const LearnAnimated1(),
    );
  }
}
