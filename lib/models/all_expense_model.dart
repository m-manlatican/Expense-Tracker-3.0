import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // REQUIRED for Timestamp

class Expense {
  final String id;
  final String title;
  final String category;
  final double amount;
  final String dateLabel;
  final Timestamp date; // FIX: Store the Firestore Timestamp here
  final String notes;
  final int iconCodePoint; 
  final int iconColorValue; 

  Expense({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.dateLabel,
    required this.date, // FIX: Include date in constructor
    required this.notes,
    required this.iconCodePoint,
    required this.iconColorValue,
  });

  // Convert Expense to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'amount': amount,
      'dateLabel': dateLabel,
      'date': date, // FIX: Ensure the Timestamp is saved back
      'notes': notes,
      'iconCodePoint': iconCodePoint,
      'iconColorValue': iconColorValue,
    };
  }

  // Convert Firestore Map to Expense
  factory Expense.fromMap(String id, Map<String, dynamic> map) {
    return Expense(
      id: id,
      title: map['title'],
      category: map['category'],
      amount: (map['amount'] as num).toDouble(),
      dateLabel: map['dateLabel'],
      date: map['date'] as Timestamp, // FIX: Extract the Timestamp
      notes: map['notes'],
      iconCodePoint: map['iconCodePoint'],
      iconColorValue: map['iconColorValue'],
    );
  }

  // Helpers to get actual IconData and Color
  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');
  Color get iconColor => Color(iconColorValue);
}