import 'package:expense_tracker_3_0/app_colors.dart'; // Import
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
                  // Soft Red Background for Expense
                  color: AppColors.expense.withOpacity(0.1), 
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.trending_down, // trending_down makes more sense for spending
                  color: AppColors.expense, // Coral Red
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Total Spent',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
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
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: LinearProgressIndicator(
              minHeight: 6,
              value: progressValue,
              backgroundColor: AppColors.background,
              // Progress bar uses the Primary or Expense color? 
              // Usually spending progress is warned with red or primary. 
              // Let's use Primary (Iris Blue) for a cool look, or Expense if > 80%?
              // Let's stick to Primary for consistency.
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${(percentage * 100).toStringAsFixed(1)}% of \$${totalBudget.toStringAsFixed(2)} budget',
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}