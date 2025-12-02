import 'package:expense_tracker_3_0/firebase_options.dart';
import 'package:expense_tracker_3_0/pages/dashboard_page.dart'; // Ensure these imports exist
import 'package:expense_tracker_3_0/pages/log_in_page.dart';   // Ensure these imports exist
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Use AuthGate to manage navigation based on login status
      home: const AuthGate(), 
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF3F5F9),
      ),
    );
  }
}

// --- AUTH GATE: Automatically switches between Login and Dashboard ---
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // Listens to Firebase authentication state changes
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading spinner while checking auth status
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // If user data exists (logged in), show Dashboard
        if (snapshot.hasData) {
          return const DashboardPage();
        }

        // Otherwise, show Login page
        return const LoginPage();
      },
    );
  }
}