import 'package:agreenect/screens/Admin/admin_screen.dart';
import 'package:agreenect/home_page.dart';
import 'package:agreenect/landing_page.dart';
import 'package:agreenect/seeds.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // / Initialize Firebase
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBaBgCiUc4gDcXxWnACdJwEQx1b3wgrIA8",
      appId: "1:860919944282:web:6bd5b89f88498592597463",
      messagingSenderId: "860919944282",
      projectId: "agreenect-d4c47",
      storageBucket: "agreenect-d4c47.firebasestorage.app",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showSemanticsDebugger: false,
      debugShowCheckedModeBanner: false,
      title: 'Agreenect',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {
        // '/': (context) => const AdminPanel(),
        '/seed': (context) => SeedDataPage(),
      },
      home: AgreeNectApp(),
    );
  }
}