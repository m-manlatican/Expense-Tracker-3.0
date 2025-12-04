import 'package:expense_tracker_3_0/cards/available_budget_card.dart';
import 'package:expense_tracker_3_0/cards/spending_overview_card.dart';
import 'package:expense_tracker_3_0/cards/total_spent_card.dart';
import 'package:expense_tracker_3_0/cards/total_budget_card.dart'; 
import 'package:expense_tracker_3_0/pages/all_expenses_page.dart'; 
import 'package:expense_tracker_3_0/widgets/head_clipper.dart';
import 'package:expense_tracker_3_0/widgets/header_title.dart';
import 'package:expense_tracker_3_0/firestore_functions.dart'; 
import 'package:expense_tracker_3_0/models/all_expense_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

const Color _primaryGreen = Color(0xFF0AA06E);

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0; 
  double _totalBudget = 5000.00; 
  late Stream<List<Expense>> _expensesStream;
  List<Widget> _widgetOptions = []; 

  @override
  void initState() {
    super.initState();
    _expensesStream = getExpenses();
    _rebuildWidgets();
  }

  // --- HELPER: Process expenses into Chart Data (Last 7 Days) ---
  Map<String, dynamic> _getChartData(List<Expense> expenses) {
    List<double> values = [];
    List<String> dates = [];
    DateTime now = DateTime.now();
    
    // Loop back 6 days + today = 7 days
    for (int i = 6; i >= 0; i--) {
      DateTime target = now.subtract(Duration(days: i));
      
      // Sum expenses that match this specific day
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

  void _rebuildWidgets() {
    _widgetOptions = <Widget>[
      StreamBuilder<List<Expense>>(
        stream: _expensesStream,
        builder: (context, snapshot) {
          double totalSpent = 0.0;
          List<double> chartValues = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
          List<String> chartDates = ['-', '-', '-', '-', '-', '-', '-'];

          if (snapshot.hasData) {
            final expenses = snapshot.data!;
            // 1. Calculate Total Spent
            totalSpent = expenses.fold(0.0, (sum, item) => sum + item.amount);
            
            // 2. Calculate Chart Data
            final chartData = _getChartData(expenses);
            chartValues = chartData['values'];
            chartDates = chartData['dates'];
          }

          return _DashboardContent(
            onViewAllExpenses: _goToExpensesTab,
            totalBudget: _totalBudget,
            totalSpent: totalSpent,
            chartValues: chartValues, // Pass data
            chartDates: chartDates,   // Pass dates
            onBudgetChanged: _updateBudget,
          );
        },
      ),
      AllExpensesPage(
        onBackTap: () => _onItemTapped(0),
      ),
      const Center(child: Text('Reports Page Content', style: TextStyle(fontSize: 24, color: _primaryGreen))),
    ];
  }

  void _updateBudget(double newBudget) {
    if (!mounted) return;
    setState(() {
      _totalBudget = newBudget;
      _rebuildWidgets(); 
    });
  }

  void _goToExpensesTab() {
    _onItemTapped(1);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_widgetOptions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex), 
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _primaryGreen,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        elevation: 10,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00C665),
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
  final VoidCallback onViewAllExpenses; 
  final double totalBudget;
  final double totalSpent;
  // Added new parameters for the chart
  final List<double> chartValues;
  final List<String> chartDates;
  final Function(double) onBudgetChanged;

  const _DashboardContent({
    required this.onViewAllExpenses,
    required this.totalBudget,
    required this.totalSpent,
    required this.chartValues,
    required this.chartDates,
    required this.onBudgetChanged,
  });

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
  
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
                  color: _primaryGreen,
                ),
              ),
            ),
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderTitle(onSignOut: _signOut), 
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
                // Pass the real calculated data
                SpendingOverviewCard(
                  spendingPoints: chartValues,
                  dateLabels: chartDates,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}