import 'package:expense_tracker_3_0/app_colors.dart';
import 'package:expense_tracker_3_0/cards/white_card.dart';
import 'package:expense_tracker_3_0/models/all_expense_model.dart';
import 'package:expense_tracker_3_0/widgets/simple_pie_chart.dart';
import 'package:flutter/material.dart';

class CategoryBreakdownCard extends StatelessWidget {
  final List<Expense> expenses;

  const CategoryBreakdownCard({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    // 1. Group expenses by Category
    final Map<String, double> categoryTotals = {};
    final Map<String, Color> categoryColors = {};

    for (var e in expenses) {
      categoryTotals[e.category] = (categoryTotals[e.category] ?? 0) + e.amount;
      categoryColors[e.category] = e.iconColor;
    }

    // 2. Prepare Data for Chart & List
    final totalSpent = expenses.fold(0.0, (sum, item) => sum + item.amount);
    
    // Convert map to list and sort by amount (High to Low)
    final List<MapEntry<String, double>> sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Create Pie Data
    final List<PieChartData> pieData = sortedCategories.map((entry) {
      return PieChartData(
        entry.value, 
        categoryColors[entry.key] ?? Colors.grey, 
        entry.key
      );
    }).toList();

    return WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Spending by Category",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          
          // --- PIE CHART CENTERED ---
          if (totalSpent > 0)
            Center(
              child: SimplePieChart(
                data: pieData,
                radius: 80, // Size of the chart
              ),
            )
          else 
            const Center(child: Text("No data to display")),

          const SizedBox(height: 30),

          // --- CATEGORY LIST ---
          ...sortedCategories.map((entry) {
            final categoryName = entry.key;
            final amount = entry.value;
            final color = categoryColors[categoryName] ?? Colors.grey;
            final percentage = totalSpent > 0 ? (amount / totalSpent) : 0.0;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 6,
                            backgroundColor: color,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            categoryName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "\$${amount.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percentage,
                      minHeight: 6,
                      backgroundColor: AppColors.background,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}