import 'package:expense_tracker_3_0/cards/all_expenses_listview.dart';
import 'package:expense_tracker_3_0/models/all_expense_model.dart';
import 'package:expense_tracker_3_0/pages/dashboard_page.dart';
import 'package:expense_tracker_3_0/pages/edit_expense_page.dart';
import 'package:expense_tracker_3_0/widgets/add_expense_fab.dart';
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

  void _editExpense(Expense expense) async {
    final updated = await Navigator.push<Map<String, dynamic>?>(
      context,
      MaterialPageRoute(
        builder: (context) => EditExpensePage(expense: expense),
      ),
    );

    if (updated != null) {
      setState(() {
        final index = _expenses.indexWhere((e) => e.id == updated['id']);
        if (index != -1) {
          _expenses[index] = Expense(
            id: updated['id'],
            title: updated['title'] ?? 'Untitled',
            category: updated['category'] ?? 'Other',
            amount: (updated['amount'] is double)
                ? updated['amount']
                : double.tryParse('${updated['amount']}') ?? 0.0,
            dateLabel: updated['dateLabel'] ?? '',
            notes: updated['notes'] ?? '',
            icon: _expenses[index].icon,
            iconColor: _expenses[index].iconColor,
          );
        }
      });
    }
  }

  // 2) Your delete function
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
        backgroundColor: const Color(0xFF0AA06E),
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
      floatingActionButton: AddExpenseFab(
        backgroundColor: const Color(0xFF00C665),
        iconSize: 30,
        onExpenseCreated: (expense) {
          setState(() {
            _expenses.add(expense);
          });
        },
      ),
    );
  }
}
