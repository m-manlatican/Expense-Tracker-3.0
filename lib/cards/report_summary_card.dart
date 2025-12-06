import 'package:expense_tracker_3_0/app_colors.dart';
import 'package:expense_tracker_3_0/cards/white_card.dart';
import 'package:flutter/material.dart';

class ReportSummaryCard extends StatelessWidget {
  final double totalIncome;
  final double totalExpenses;

  const ReportSummaryCard({
    super.key,
    required this.totalIncome,
    required this.totalExpenses,
  });

  @override
  Widget build(BuildContext context) {
    final double netProfit = totalIncome - totalExpenses;
    final bool isPositive = netProfit >= 0;

    return WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Profit & Loss",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          
          // Net Profit (Hero Metric)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isPositive ? AppColors.primary.withOpacity(0.1) : AppColors.expense.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isPositive ? AppColors.primary.withOpacity(0.3) : AppColors.expense.withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                Text(
                  "Net Profit",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isPositive ? AppColors.primary : AppColors.expense,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "₱${netProfit.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: isPositive ? AppColors.primary : AppColors.expense,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Income vs Expenses Row
          Row(
            children: [
              Expanded(
                child: _SummaryBox(
                  label: "Total Sales",
                  amount: totalIncome,
                  color: AppColors.success, 
                  icon: Icons.trending_up,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryBox(
                  label: "Total Expenses",
                  amount: totalExpenses,
                  color: AppColors.expense, 
                  icon: Icons.trending_down,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryBox extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;

  const _SummaryBox({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(fontSize: 12, color: AppColors.textPrimary.withOpacity(0.7), overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "₱${amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color, 
            ),
          ),
        ],
      ),
    );
  }
}