import 'package:agreenect/home_page.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const AgreeNectApp());
}

class AgreeNectApp extends StatelessWidget {
  const AgreeNectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgreeNect - Youth-Led AgriTech',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(height: 1.6),
        ),
      ),
      home: const HomePage(),
    );
  }
}