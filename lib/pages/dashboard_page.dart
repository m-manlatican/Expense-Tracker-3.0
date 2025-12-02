import 'package:expense_tracker_3_0/cards/available_budget_card.dart';
import 'package:expense_tracker_3_0/cards/quick_action_card.dart';
import 'package:expense_tracker_3_0/cards/spending_overview_card.dart';
import 'package:expense_tracker_3_0/cards/total_spent_card.dart';
// IMPORT THE NEW PAGES
import 'package:expense_tracker_3_0/pages/add_expense_page.dart'; 
import 'package:expense_tracker_3_0/pages/all_expenses_page.dart'; 
import 'package:expense_tracker_3_0/widgets/head_clipper.dart';
import 'package:expense_tracker_3_0/widgets/header_title.dart';
import 'package:expense_tracker_3_0/widgets/quick_action.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // 1. GREEN HEADER BACKGROUND
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

            // 2. MAIN SCROLLABLE CONTENT
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderTitle(),
                  const SizedBox(height: 20),
                  const TotalSpentCard(),
                  const SizedBox(height: 12),

                  // --- LINK TO "ALL EXPENSES" PAGE ---
                  GestureDetector(
                    onTap: () {
                       Navigator.push(
                         context, 
                         MaterialPageRoute(builder: (_) => const AllExpensesPage())
                       );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Recent Transactions", 
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                          ),
                          Text(
                            "See All", 
                            style: TextStyle(color: Color(0xFF0AA06E), fontWeight: FontWeight.bold)
                          ),
                        ],
                      ),
                    ),
                  ),

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

            // 3. LOGOUT BUTTON (Top Right)
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                onPressed: () => _signOut(context),
                icon: const Icon(Icons.logout, color: Colors.white),
                tooltip: "Sign Out",
              ),
            ),

            // 4. FLOATING ACTION BUTTON (The Fix)
            Positioned(
              bottom: 15,
              right: 15,
              child: FloatingActionButton(
                backgroundColor: const Color(0xFF00C665),
                heroTag: 'add_expense_btn', 
                onPressed: () {
                  // Navigate to the Add Expense Form
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddExpensePage()),
                  );
                },
                child: const Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}