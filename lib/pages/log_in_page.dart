import 'package:expense_tracker_3_0/app_colors.dart';
import 'package:expense_tracker_3_0/pages/register_page.dart';
import 'package:expense_tracker_3_0/services/auth_service.dart'; 
import 'package:expense_tracker_3_0/widgets/form_fields.dart'; 
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
  final AuthService _authService = AuthService();
  
  String? _emailError;
  String? _passwordError;
  bool isLoading = false;

  void _clearErrors() {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });
  }

  Future<void> _login() async {
    _clearErrors();
    
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    bool isValid = true;

    // 1. Validation
    if (email.isEmpty) {
      setState(() => _emailError = "Email is required");
      isValid = false;
    } else if (!email.contains('@')) {
      setState(() => _emailError = "Invalid email format");
      isValid = false;
    }

    if (password.isEmpty) {
      setState(() => _passwordError = "Password is required");
      isValid = false;
    }

    if (!isValid) return;

    try {
      setState(() => isLoading = true);

      // 2. Attempt Sign In
      await _authService.signIn(email, password);

      // 3. 🔥 SUCCESS MESSAGE (Persists to Dashboard)
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.check_circle_rounded, color: Colors.white),
              SizedBox(width: 12),
              Text(
                "Logged in successfully",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          backgroundColor: AppColors.success, // Mint Green for Success
          behavior: SnackBarBehavior.floating, // Floats nicely
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          elevation: 4,
          duration: const Duration(seconds: 2), // Short and sweet
        ),
      );

      // Note: No need to Navigator.push here because AuthGate 
      // automatically redirects when the auth state changes.

    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      
      setState(() {
        if (e.code == 'user-not-found') {
          _emailError = "Incorrect email.";
        } 
        else if (e.code == 'wrong-password') {
          _passwordError = "Incorrect password.";
        } 
        else if (e.code == 'invalid-credential') {
          _emailError = "Incorrect email or password.";
          _passwordError = " "; 
        } 
        else if (e.code == 'user-disabled') {
          _emailError = "This account has been disabled.";
        } 
        else if (e.code == 'invalid-email') {
          _emailError = "Invalid email format.";
        } 
        else {
          // Generic Error
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.message ?? "Authentication failed"),
            backgroundColor: AppColors.expense,
            behavior: SnackBarBehavior.floating,
          ));
        }
      });
    } catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("An error occurred: $e"),
          backgroundColor: AppColors.expense,
        ));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded, 
                    size: 48, 
                    color: AppColors.primary
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 32, 
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Sign in to manage your expenses.",
                  style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 40),
                
                // Form
                const FormLabel("Email Address"),
                const SizedBox(height: 8),
                RoundedTextField(
                  controller: emailController,
                  hintText: "hello@example.com",
                  prefix: const Icon(Icons.email_outlined),
                  keyboardType: TextInputType.emailAddress,
                  errorText: _emailError,
                  onChanged: (_) {
                    if (_emailError != null) setState(() => _emailError = null);
                  },
                ),
                const SizedBox(height: 20),
                
                const FormLabel("Password"),
                const SizedBox(height: 8),
                RoundedTextField(
                  controller: passwordController,
                  hintText: "••••••••",
                  prefix: const Icon(Icons.lock_outline),
                  obscureText: true,
                  errorText: _passwordError,
                  onChanged: (_) {
                    if (_passwordError != null) setState(() => _passwordError = null);
                  },
                ),
                
                const SizedBox(height: 40),
                
                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary, 
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 8,
                      shadowColor: AppColors.primary.withOpacity(0.3),
                    ),
                    child: isLoading 
                      ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5)) 
                      : const Text("Sign In", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage()));
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}