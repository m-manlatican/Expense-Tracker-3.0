import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Expose Auth State Stream for AuthGate
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get Current User ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Sign In
  Future<UserCredential> signIn(String email, String password) async {
    // We use signInWithEmailAndPassword directly to avoid enumeration protection issues
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Register
  Future<UserCredential> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    UserCredential cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Create user document in Firestore
    await _firestore.collection('users').doc(cred.user!.uid).set({
      'fullName': fullName,
      'email': email,
      'createdAt': Timestamp.now(),
    });

    return cred;
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}