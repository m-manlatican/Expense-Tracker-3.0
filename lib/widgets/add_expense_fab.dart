import 'package:expense_tracker_3_0/app_colors.dart';
import 'package:expense_tracker_3_0/models/all_expense_model.dart';
import 'package:expense_tracker_3_0/services/firestore_service.dart'; // 🔥 Import Service
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

typedef ExpenseCallback = void Function(Expense expense);

class AddExpenseFab extends StatelessWidget {
  final Color backgroundColor;
  final double iconSize;
  final IconData icon;
  final ExpenseCallback? onExpenseCreated;
  
  // 🔥 Create instance of the service
  final FirestoreService _firestoreService = FirestoreService();

  AddExpenseFab({
    super.key,
    this.backgroundColor = AppColors.primary, // Updated to Theme
    this.iconSize = 24,
    this.icon = Icons.add,
    this.onExpenseCreated,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: backgroundColor,
      child: Icon(icon, color: Colors.white, size: iconSize),
      onPressed: () async {
        // Open AddExpensePage using named route (if configured) or direct push
        // Note: If you are using named routes in main.dart, use Navigator.pushNamed.
        // If sticking to the previous logic of pushing the page directly:
        
        final data = await Navigator.pushNamed(context, '/add_expense') as Map<String, dynamic>?;

        // If you are NOT using named routes for this return value, use:
        // final data = await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddExpensePage()));

        if (data != null) {
          // Create Expense Object
          final expense = Expense(
            id: '', // Firestore generates this
            title: data["title"] ?? 'Untitled',
            category: data["category"] ?? 'Other',
            amount: (data["amount"] is double)
                ? data["amount"]
                : double.tryParse('${data["amount"]}') ?? 0.0,
            dateLabel: data["dateLabel"] ?? '',
            date: Timestamp.now(), 
            notes: data["notes"] ?? '',
            iconCodePoint: data["iconCodePoint"] ?? Icons.receipt_long.codePoint,
            iconColorValue: data["iconColorValue"] ?? const Color(0xFF30D177).value,
          );

          // 🔥 FIX: Use the service instead of the old function
          await _firestoreService.addExpense(expense);

          if (onExpenseCreated != null) {
            onExpenseCreated!(expense);
          }
        }
      },
    );
  }
}