import 'package:expense_tracker_3_0/cards/all_expenses_listview.dart';
import 'package:expense_tracker_3_0/models/all_expense_model.dart';
import 'package:expense_tracker_3_0/pages/edit_expense_page.dart';
import 'package:flutter/material.dart';
import '../firestore_functions.dart'; 

class AllExpensesPage extends StatefulWidget {
  const AllExpensesPage({super.key});

  @override
  AllExpensesPageState createState() => AllExpensesPageState();
}

class AllExpensesPageState extends State<AllExpensesPage> {
  
  void _editExpense(Expense expense) async {
    // Ensure you have created EditExpensePage, or comment this out for now
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditExpensePage(expense: expense)),
    );
  }

  void _deleteExpense(Expense expense) async {
    await deleteExpense(expense.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0AA06E),
        elevation: 0,
        title: const Text('All Expenses', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            // ✅ CORRECT: Use pop to go back, don't push a new Dashboard
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: StreamBuilder<List<Expense>>(
          stream: getExpenses(), // Ensure this function exists in firestore_functions.dart
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No expenses yet.'));
            }

            return AllExpensesListView(
              expenses: snapshot.data!,
              onEdit: _editExpense,
              onDelete: _deleteExpense,
            );
          },
        ),
      ),
      // Removed the FAB from here since we add expenses from Dashboard usually,
      // but if you want it, use the standard FloatingActionButton logic like in Dashboard.
    );
  }
}