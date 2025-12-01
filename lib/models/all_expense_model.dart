import 'package:flutter/material.dart';

class Expense {
  final String id;
  final String title;
  final String category;
  final double amount;
  final String dateLabel;
  final String notes;
  final IconData icon;
  final Color iconColor;

  Expense({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.dateLabel,
    required this.notes,
    required this.icon,
    required this.iconColor,
  });
}
