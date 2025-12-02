import 'package:expense_tracker_3_0/pages/dashboard_page.dart';
import 'package:expense_tracker_3_0/pages/log_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 1. If connection is waiting, show loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // 2. If we have a user data, show Dashboard
        if (snapshot.hasData) {
          return const DashboardPage();
        }

        // 3. Otherwise, show Login
        return const LoginPage();
      },
    );
  }
}