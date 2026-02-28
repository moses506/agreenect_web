
import 'package:agreenect/home_page.dart';
import 'package:agreenect/landing_page.dart';
import 'package:agreenect/screens/Admin/admin_screen.dart';
import 'package:agreenect/screens/Admin/login.dart';
import 'package:agreenect/seeds.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey:            "AIzaSyBaBgCiUc4gDcXxWnACdJwEQx1b3wgrIA8",
      appId:             "1:860919944282:web:6bd5b89f88498592597463",
      messagingSenderId: "860919944282",
      projectId:         "agreenect-d4c47",
      storageBucket:     "agreenect-d4c47.firebasestorage.app",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,
      title: 'Agreenect',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      // AuthGate decides what screen to show on launch
      home: const AuthGate(),
      routes: {
        '/login':     (context) => const AdminLoginPage(),
        '/dashboard': (context) => const AdminDashboard(),
        '/seed':      (context) => const SeedDataPage(),
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AUTH GATE
// Listens to Firebase auth state. If a user session already exists
// (persisted from last login) they go straight to the dashboard.
// Otherwise they land on the login page.
// ─────────────────────────────────────────────────────────────────────────────
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // ── Still waiting for Firebase to respond ──────────────────────────
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _SplashScreen();
        }

        // ── User is logged in → Dashboard ──────────────────────────────────
        if (snapshot.hasData && snapshot.data != null) {
          return const AgreeNectApp();
        }

        // ── No session → Login ─────────────────────────────────────────────
        return const AdminLoginPage();
        // return const AgreeNectApp();
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SPLASH SCREEN (shown for ~1 second while Firebase checks auth state)
// ─────────────────────────────────────────────────────────────────────────────
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0F2419), // _C.deep
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🌿', style: TextStyle(fontSize: 52)),
            SizedBox(height: 20),
            Text(
              'Agreenect',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Admin Panel',
              style: TextStyle(
                color: Color(0xFF8A9E88), // _C.ash
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 36),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Color(0xFF7FD17A), // _C.lime
                strokeWidth: 2.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}