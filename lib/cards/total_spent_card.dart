import 'package:expense_tracker_3_0/cards/white_card.dart';
import 'package:flutter/material.dart';

class TotalSpentCard extends StatelessWidget {
  final double spentAmount;
  final double totalBudget;

  const TotalSpentCard({
    super.key, 
    required this.spentAmount, 
    required this.totalBudget
  });

  @override
  Widget build(BuildContext context) {
    // Math Logic
    double percentage = totalBudget > 0 ? (spentAmount / totalBudget) : 0.0;
    double progressValue = percentage.clamp(0.0, 1.0);

    return WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEEF0), // Preserved exact color
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Color(0xFFFF4E6A), // Preserved exact color
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Total Spent',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '\$${spentAmount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: LinearProgressIndicator(
              minHeight: 6,
              value: progressValue,
              backgroundColor: const Color(0xFFE9EDF5),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00C665)),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${(percentage * 100).toStringAsFixed(1)}% of \$${totalBudget.toStringAsFixed(2)} budget',
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}