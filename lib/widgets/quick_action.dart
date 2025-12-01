import 'package:flutter/material.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'View All Expenses',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF00B77B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}