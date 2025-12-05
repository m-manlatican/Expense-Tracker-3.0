import 'package:expense_tracker_3_0/app_colors.dart';
import 'package:expense_tracker_3_0/cards/category_breakdown_card.dart';
import 'package:expense_tracker_3_0/cards/report_summary_card.dart';
import 'package:expense_tracker_3_0/models/all_expense_model.dart';
import 'package:expense_tracker_3_0/services/firestore_service.dart';
import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  final VoidCallback? onBackTap;
  final FirestoreService _firestoreService = FirestoreService(); 

  ReportsPage({
    super.key, 
    this.onBackTap
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
                  onTap: () => onBackTap != null ? onBackTap!() : null,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Business Reports",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),

          // Content
          Expanded(
            child: StreamBuilder<List<Expense>>(
              stream: _firestoreService.getExpensesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }
                
                final allTransactions = snapshot.data ?? [];
                final activeTransactions = allTransactions.where((e) => !e.isDeleted).toList();
                
                // 🔥 Business Calculations
                final totalIncome = activeTransactions
                    .where((e) => e.isIncome)
                    .fold(0.0, (sum, item) => sum + item.amount);
                
                final totalExpenses = activeTransactions
                    .where((e) => !e.isIncome && !e.isCapital)
                    .fold(0.0, (sum, item) => sum + item.amount);

                // Separate lists for breakdown charts
                final expenseTransactions = activeTransactions.where((e) => !e.isIncome && !e.isCapital).toList();
                final incomeTransactions = activeTransactions.where((e) => e.isIncome).toList();

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // 1. Profit & Loss Summary
                      ReportSummaryCard(
                        totalIncome: totalIncome, 
                        totalExpenses: totalExpenses,
                      ),
                      const SizedBox(height: 16),
                      
                      // 2. Income Breakdown (Where money comes from)
                      if (incomeTransactions.isNotEmpty)
                        CategoryBreakdownCard(
                          title: "Income Sources",
                          expenses: incomeTransactions,
                          isIncome: true,
                        ),
                        
                      const SizedBox(height: 16),

                      // 3. Expense Breakdown (Where money goes)
                      if (expenseTransactions.isNotEmpty)
                        CategoryBreakdownCard(
                          title: "Expense Breakdown",
                          expenses: expenseTransactions,
                          isIncome: false,
                        ),
                        
                      if (incomeTransactions.isEmpty && expenseTransactions.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Text("No transactions available for reports.", style: TextStyle(color: Colors.grey)),
                        ),

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