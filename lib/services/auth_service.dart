import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Login Method
  Future<UserCredential> signIn(String email, String password) async {
    try {
      // We must attempt sign-in directly because 'fetchSignInMethodsForEmail' 
      // is blocked by Firebase's default security settings.
      return await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
    } catch (e) {
      rethrow; // Pass error to UI to handle
    }
  }

  // Register Method
  Future<UserCredential> register({
    required String email, 
    required String password, 
    required String fullName
  }) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );

      // Save user data to Firestore
      await _firestore.collection('users').doc(cred.user!.uid).set({
        'fullName': fullName,
        'email': email,
        'createdAt': Timestamp.now(),
      });

      return cred;
    } catch (e) {
      rethrow;
    }
  }
}