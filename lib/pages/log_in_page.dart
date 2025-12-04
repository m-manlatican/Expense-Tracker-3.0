import 'package:expense_tracker_3_0/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  // UNIFIED THEME COLORS
  final Color primaryGreen = const Color(0xFF0AA06E);
  final Color scaffoldBg = const Color(0xFFF3F5F9);

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    try {
      setState(() => isLoading = true);
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message ?? 'Login failed'),
        backgroundColor: Colors.red,
      ));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBg, // Unified Background
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        automaticallyImplyLeading: false, 
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          children: [
            Icon(Icons.heat_pump_rounded, size: 50, color: primaryGreen), // Unified Icon Color
            const SizedBox(height: 10),
            const Text(
              "Welcome Back",
              style: TextStyle(
                fontSize: 28, 
                fontWeight: FontWeight.bold,
                color: Colors.black87
              ),
            ),
            const SizedBox(height: 40),
            
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: const TextStyle(color: Colors.black54),
                prefixIcon: const Icon(Icons.email, color: Colors.black54),
                // Using standard borders but with Theme Green focus
                border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black38)),
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black38)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryGreen, width: 2)),
              ),
            ),
            const SizedBox(height: 20),
            
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: const TextStyle(color: Colors.black54),
                prefixIcon: const Icon(Icons.lock, color: Colors.black54),
                border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black38)),
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black38)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryGreen, width: 2)),
              ),
            ),
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen, // Unified Button Color
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
                child: isLoading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                  : const Text("Sign In", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
            
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage()));
              },
              child: Text(
                "Don't have an account? Register",
                style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w600), // Unified Text Link
              ),
            ),
          ],
        ),
      ),
    );
  }
}