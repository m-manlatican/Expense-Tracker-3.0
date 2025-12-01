import 'package:expense_tracker_3_0/cards/all_expenses_listview.dart';
import 'package:expense_tracker_3_0/models/all_expense_model.dart';
import 'package:expense_tracker_3_0/pages/add_expense_page.dart';
import 'package:expense_tracker_3_0/pages/dashboard_page.dart';
import 'package:flutter/material.dart';

class AllExpensesPage extends StatefulWidget {
  const AllExpensesPage({super.key});

  @override
  AllExpensesPageState createState() => AllExpensesPageState();
}

// NOTE: public state class name (no leading underscore)
class AllExpensesPageState extends State<AllExpensesPage> {
  // start with some sample expenses
  final List<Expense> _expenses = [];

  void _editExpense(Expense expense) {
    // implement edit if needed
  }

  void _deleteExpense(Expense expense) {
    setState(() {
      _expenses.removeWhere((e) => e.id == expense.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF009846),
        elevation: 0,
        title: const Text(
          'All Expenses',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: AllExpensesListView(
          expenses: _expenses,
          onEdit: _editExpense,
          onDelete: _deleteExpense,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00A54C),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          // open AddExpensePage and wait for returned data
          final data = await Navigator.push<Map<String, dynamic>?>(
            context,
            MaterialPageRoute(builder: (context) => const AddExpensePage()),
          );

          // if user saved, data is a map with fields we expect
          if (data != null) {
            setState(() {
              _expenses.add(
                Expense(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: data["title"] ?? 'Untitled',
                  category: data["category"] ?? 'Other',
                  amount: (data["amount"] is double)
                      ? data["amount"]
                      : double.tryParse('${data["amount"]}') ?? 0.0,
                  dateLabel: data["dateLabel"] ?? '',
                  notes: data["notes"] ?? '',
                  icon: Icons.receipt_long,
                  iconColor: const Color(0xFF30D177),
                ),
              );
            });
          }
        },
      ),
    );
  }
}
