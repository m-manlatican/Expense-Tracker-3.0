import 'package:expense_tracker_3_0/models/all_expense_model.dart';
import 'package:flutter/material.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ExpenseCard({
    super.key,
    required this.expense,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: expense.iconColor.withOpacity(0.15),
                child: Icon(expense.icon, color: expense.iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      expense.category,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '\$${expense.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Color(0xFF009846),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                expense.dateLabel,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          if (expense.notes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                expense.notes,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF555555),
                ),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF30D177),
                  backgroundColor: const Color(0xFFEDFCF5),
                ),
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Edit'),
                onPressed: onEdit,
              ),
              const SizedBox(width: 10),
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFF44234),
                  backgroundColor: const Color(0xFFFDE6E4),
                ),
                icon: const Icon(Icons.delete, size: 16),
                label: const Text('Delete'),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
