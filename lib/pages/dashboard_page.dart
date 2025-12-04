import 'package:expense_tracker_3_0/app_colors.dart'; 
import 'package:expense_tracker_3_0/cards/available_budget_card.dart';
import 'package:expense_tracker_3_0/cards/spending_overview_card.dart';
import 'package:expense_tracker_3_0/cards/total_spent_card.dart';
import 'package:expense_tracker_3_0/cards/total_budget_card.dart'; 
import 'package:expense_tracker_3_0/pages/all_expenses_page.dart'; 
import 'package:expense_tracker_3_0/pages/reports_page.dart'; 
import 'package:expense_tracker_3_0/widgets/head_clipper.dart';
import 'package:expense_tracker_3_0/widgets/header_title.dart';
import 'package:expense_tracker_3_0/firestore_functions.dart'; 
import 'package:expense_tracker_3_0/models/all_expense_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0; 
  double _totalBudget = 0.00; 
  late Stream<List<Expense>> _expensesStream;

  @override
  void initState() {
    super.initState();
    _expensesStream = getExpenses();
  }

  Map<String, dynamic> _getChartData(List<Expense> expenses) {
    List<double> values = [];
    List<String> dates = [];
    DateTime now = DateTime.now();
    for (int i = 6; i >= 0; i--) {
      DateTime target = now.subtract(Duration(days: i));
      double dailySum = expenses.where((e) {
        DateTime eDate = e.date.toDate();
        return eDate.year == target.year && 
               eDate.month == target.month && 
               eDate.day == target.day;
      }).fold(0.0, (sum, item) => sum + item.amount);
      values.add(dailySum);
      dates.add("${target.month}/${target.day}");
    }
    return {'values': values, 'dates': dates};
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _updateBudget(double newBudget) {
    if (!mounted) return;
    setState(() {
      _totalBudget = newBudget;
    });
  }

  // 🔥 UPDATED: Shows a confirmation dialog before signing out
  Future<void> _signOut() async {
    final bool? shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Matches App Cards
          ),
          backgroundColor: Colors.white,
          title: const Text(
            "Sign Out",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "Are you sure you want to log out of your account?",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.expense, // Coral Red for "Exit" action
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                "Sign Out",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );

    if (shouldSignOut == true) {
      await FirebaseAuth.instance.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      // 0: HOME
      StreamBuilder<List<Expense>>(
        stream: _expensesStream,
        builder: (context, snapshot) {
          double totalSpent = 0.0;
          List<double> chartValues = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
          List<String> chartDates = ['-', '-', '-', '-', '-', '-', '-'];

          if (snapshot.hasData) {
            final expenses = snapshot.data!;
            totalSpent = expenses.fold(0.0, (sum, item) => sum + item.amount);
            final chartData = _getChartData(expenses);
            chartValues = chartData['values'];
            chartDates = chartData['dates'];
          }

          return _DashboardContent(
            totalBudget: _totalBudget,
            totalSpent: totalSpent,
            chartValues: chartValues,
            chartDates: chartDates,
            onBudgetChanged: _updateBudget,
            onSignOut: _signOut,
          );
        },
      ),

      // 1: EXPENSES
      AllExpensesPage(
        onBackTap: () => _onItemTapped(0),
      ),

      // 2: REPORTS
      ReportsPage(
        totalBudget: _totalBudget,
        onBackTap: () => _onItemTapped(0),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: pages[_selectedIndex], 

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            activeIcon: Icon(Icons.pie_chart),
            label: 'Reports',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, 
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        elevation: 15,
      ),
      
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        heroTag: 'add_expense_btn', 
        onPressed: () {
          Navigator.pushNamed(context, '/add_expense');
        },
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final double totalBudget;
  final double totalSpent;
  final List<double> chartValues;
  final List<String> chartDates;
  final Function(double) onBudgetChanged;
  final VoidCallback onSignOut;

  const _DashboardContent({
    required this.totalBudget,
    required this.totalSpent,
    required this.chartValues,
    required this.chartDates,
    required this.onBudgetChanged,
    required this.onSignOut,
  });
  
  @override
  Widget build(BuildContext context) {
    final double availableBalance = totalBudget - totalSpent;

    return SafeArea(
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: ClipPath(
                clipper: HeaderClipper(),
                child: Container(
                  height: 260,
                  color: AppColors.primary, 
                ),
              ),
            ),
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderTitle(onSignOut: onSignOut), 
                const SizedBox(height: 20),
                
                TotalBudgetCard(
                  currentBudget: totalBudget,
                  onBudgetChanged: onBudgetChanged,
                ),

                const SizedBox(height: 12),
                
                TotalSpentCard(
                  spentAmount: totalSpent,
                  totalBudget: totalBudget,
                ),

                const SizedBox(height: 12),
                
                AvailableBudgetCard(
                  balance: availableBalance,
                ),
                
                const SizedBox(height: 16),
                SpendingOverviewCard(
                  spendingPoints: chartValues,
                  dateLabels: chartDates,
                ),
                const SizedBox(height: 80), 
              ],
            ),
          ),
        ],
      ),
    );
  }
}