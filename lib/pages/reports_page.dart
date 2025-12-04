import 'package:expense_tracker_3_0/app_colors.dart';
import 'package:expense_tracker_3_0/cards/category_breakdown_card.dart';
import 'package:expense_tracker_3_0/cards/report_summary_card.dart';
import 'package:expense_tracker_3_0/firestore_functions.dart';
import 'package:expense_tracker_3_0/models/all_expense_model.dart';
import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  final double totalBudget;
  final VoidCallback? onBackTap;

  const ReportsPage({
    super.key, 
    required this.totalBudget,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    if (onBackTap != null) onBackTap!();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Reports",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 40), 
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: StreamBuilder<List<Expense>>(
              stream: getExpenses(),
              builder: (context, snapshot) {
                // If loading, show spinner
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }
                
                // 🔥 FIXED: Always initialize expenses list, even if null
                final expenses = snapshot.data ?? [];
                final totalSpent = expenses.fold(0.0, (sum, item) => sum + item.amount);

                // 🔥 REMOVED: The "if expenses.isEmpty return Text" block.
                // Now it falls through to render the cards with 0 values.

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // 1. Spending Summary Card (Shows $0.00 if empty)
                      ReportSummaryCard(
                        totalBudget: totalBudget, 
                        totalSpent: totalSpent, 
                        expenseCount: expenses.length,
                      ),
                      const SizedBox(height: 16),
                      
                      // 2. Breakdown Pie Chart Card (Shows "No data" inside the card structure)
                      CategoryBreakdownCard(expenses: expenses),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}