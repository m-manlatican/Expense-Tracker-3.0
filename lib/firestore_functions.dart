import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense_tracker_3_0/models/all_expense_model.dart';
import 'package:flutter/foundation.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// --- CRITICAL HELPER: Gets the current user's expense collection ---
CollectionReference _getUserExpenseCollection() {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) {
    throw Exception("User must be logged in to access expense data.");
  }
  
  // Path: users/{userId}/expenses
  return _firestore
      .collection('users')
      .doc(userId)
      .collection('expenses');
}

// --- 1. ADD EXPENSE (Used for creation) ---
Future<void> addExpense(Expense expense) async {
  try {
    // .add() creates a document with a new, random ID
    await _getUserExpenseCollection().add(expense.toMap());
  } catch (e) {
    debugPrint('Error adding expense: $e');
    rethrow;
  }
}

// 🔥 NEW: 2. UPDATE EXPENSE (Used for editing) ---
Future<void> updateExpense(Expense expense) async {
  try {
    // .doc(expense.id).set() targets the existing document ID
    // SetOptions(merge: false) ensures the entire document is overwritten with new data.
    await _getUserExpenseCollection()
        .doc(expense.id)
        .set(expense.toMap());
  } catch (e) {
    debugPrint('Error updating expense: $e');
    rethrow;
  }
}

// --- 3. GET EXPENSES ---
Stream<List<Expense>> getExpenses() {
  try {
    return _getUserExpenseCollection()
        .orderBy('date', descending: true) 
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Expense.fromMap(doc.id, doc.data() as Map<String, dynamic>))
              .toList();
        });
  } catch (e) {
    debugPrint('Error fetching expenses: $e');
    return Stream.value([]); 
  }
}

// --- 4. DELETE EXPENSE ---
Future<void> deleteExpense(String id) async {
  try {
    await _getUserExpenseCollection().doc(id).delete();
  } catch (e) {
    debugPrint('Error deleting expense: $e');
    rethrow;
  }
}