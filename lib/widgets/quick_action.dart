import 'package:expense_tracker_3_0/pages/all_expenses_page.dart';
import 'package:flutter/material.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AllExpensesPage()),
            );
          }, 
          child: Text(
          'View All Expenses',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF00B77B),
            fontWeight: FontWeight.w500,
          ),
        ),)
      ],
    );
  }
}