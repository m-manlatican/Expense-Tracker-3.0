import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_3_0/models/all_expense_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DocumentReference? get _userDoc {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return null;
    return _firestore.collection('users').doc(userId);
  }

  // 🔥 UPDATED: Smart Name Retrieval (Handles Old & New Users)
  Stream<String> getUserName() {
    final ref = _userDoc;
    if (ref == null) return Stream.value("User");

    return ref.snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data() as Map<String, dynamic>;
        
        // 1. Try to get the NEW 'firstName' field
        if (data.containsKey('firstName') && data['firstName'] != null) {
           final String first = data['firstName'];
           if (first.isNotEmpty) return first;
        }
        
        // 2. Fallback: If no firstName, try OLD 'fullName'
        if (data.containsKey('fullName') && data['fullName'] != null) {
           final String full = data['fullName'];
           if (full.isNotEmpty) {
             // Split string by space and take the first part (e.g. "John Doe" -> "John")
             return full.split(' ').first;
           }
        }
      }
      // 3. Default if absolutely nothing is found
      return "User";
    });
  }

  // --- BUDGET METHODS ---
  Stream<double> getUserBudgetStream() {
    final ref = _userDoc;
    if (ref == null) return Stream.value(0.0);

    return ref.snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data() as Map<String, dynamic>;
        return (data['totalBudget'] as num?)?.toDouble() ?? 0.0;
      }
      return 0.0;
    });
  }

  Future<void> updateUserBudget(double newBudget) async {
    final ref = _userDoc;
    if (ref == null) throw Exception("User not logged in");
    await ref.set({'totalBudget': newBudget}, SetOptions(merge: true));
  }

  // --- EXPENSE METHODS ---
  Stream<List<Expense>> getExpensesStream() {
    final ref = _userDoc?.collection('expenses');
    if (ref == null) return Stream.value([]);

    return ref.orderBy('date', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Expense.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Future<void> addExpense(Expense expense) async {
    final ref = _userDoc?.collection('expenses');
    if (ref == null) throw Exception("User not logged in");
    await ref.add(expense.toMap());
  }

  Future<void> updateExpense(Expense expense) async {
    final ref = _userDoc?.collection('expenses');
    if (ref == null) throw Exception("User not logged in");
    await ref.doc(expense.id).update(expense.toMap());
  }

  Future<void> deleteExpense(String id) async {
    final ref = _userDoc?.collection('expenses');
    if (ref == null) throw Exception("User not logged in");
    await ref.doc(id).update({'isDeleted': true});
  }

  Future<void> restoreExpense(String id) async {
    final ref = _userDoc?.collection('expenses');
    if (ref == null) throw Exception("User not logged in");
    await ref.doc(id).update({'isDeleted': false});
  }

  Future<void> permanentlyDeleteExpense(String id) async {
    final ref = _userDoc?.collection('expenses');
    if (ref == null) throw Exception("User not logged in");
    await ref.doc(id).delete();
  }

  Future<void> clearHistory() async {
    final ref = _userDoc?.collection('expenses');
    if (ref == null) throw Exception("User not logged in");

    final snapshot = await ref.where('isDeleted', isEqualTo: true).get();
    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}