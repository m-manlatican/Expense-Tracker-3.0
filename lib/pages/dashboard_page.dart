import 'package:expense_tracker_3_0/cards/available_budget_card.dart';
import 'package:expense_tracker_3_0/cards/quick_action_card.dart';
import 'package:expense_tracker_3_0/cards/spending_overview_card.dart';
import 'package:expense_tracker_3_0/cards/total_spent_card.dart';
import 'package:expense_tracker_3_0/pages/add_expense_page.dart';
import 'package:expense_tracker_3_0/widgets/head_clipper.dart';
import 'package:expense_tracker_3_0/widgets/header_title.dart';
import 'package:expense_tracker_3_0/widgets/quick_action.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Green header background
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: ClipPath(
                  clipper: HeaderClipper(),
                  child: Container(
                    height: 260,
                    color: const Color(0xFF0AA06E),
                  ),
                ),
              ),
            ),
            // Content
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderTitle(),
                  const SizedBox(height: 20),
                  const TotalSpentCard(),
                  const SizedBox(height: 12),
                  AvailableBudgetCard(),
                  const SizedBox(height: 16),
                  SpendingOverviewCard(),
                  const SizedBox(height: 16),
                  const QuickActions(),
                  const SizedBox(height: 20),
                  const QuickActionCard(),
                  const SizedBox(height: 20),
                  const QuickActionCard()
                ],
              ),
            ),
            // Floating "+" button at bottom right
            Positioned(
              bottom: 24,
              right: 24,
              child: FloatingActionButton(
                backgroundColor: const Color(0xFF00C665),
                elevation: 4,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddExpensePage()),
                  );
                },
                child: const Icon(Icons.add, size: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}