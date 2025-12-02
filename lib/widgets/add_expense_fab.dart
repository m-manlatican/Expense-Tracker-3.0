import 'package:expense_tracker_3_0/models/all_expense_model.dart';
import 'package:expense_tracker_3_0/pages/add_expense_page.dart';
import 'package:flutter/material.dart';

typedef ExpenseCallback = void Function(Expense expense);

class AddExpenseFab extends StatelessWidget {
  final Color backgroundColor;
  final double iconSize;
  final IconData icon;
  final ExpenseCallback? onExpenseCreated;

  const AddExpenseFab({
    super.key,
    this.backgroundColor = const Color(0xFF00A54C),
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
        // always open the same AddExpensePage
        final data = await Navigator.push<Map<String, dynamic>?>(
          context,
          MaterialPageRoute(builder: (context) => const AddExpensePage()),
        );

        // If this page cares about the created expense, convert and return it
        if (data != null && onExpenseCreated != null) {
          final expense = Expense(
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
          );
          onExpenseCreated!(expense);
        }
      },
    );
  }
}