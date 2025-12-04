import 'package:expense_tracker_3_0/app_colors.dart';
import 'package:expense_tracker_3_0/cards/all_expenses_listview.dart';
import 'package:expense_tracker_3_0/models/all_expense_model.dart';
import 'package:expense_tracker_3_0/widgets/expense_filter_modal.dart'; // Import the new widget
import 'package:flutter/material.dart';
import '../firestore_functions.dart'; 

class AllExpensesPage extends StatefulWidget {
  final VoidCallback? onBackTap; 

  const AllExpensesPage({super.key, this.onBackTap});

  @override
  AllExpensesPageState createState() => AllExpensesPageState();
}

class AllExpensesPageState extends State<AllExpensesPage> {
  // FILTER STATE
  List<String> _selectedCategories = [];
  SortOption _currentSort = SortOption.newest;
  
  // Available categories (Same as Add Page)
  final List<String> _allCategories = ['Food', 'Transport', 'Shopping', 'Bills', 'Entertainment', 'Health', 'Other'];

  void _editExpense(Expense expense) async {
    await Navigator.pushNamed(context, '/edit_expense', arguments: expense);
  }

  void _deleteExpense(Expense expense) async {
    await deleteExpense(expense.id);
  }

  // 🔥 OPEN FILTER MODAL
  void _openFilterModal() async {
    final result = await showModalBottomSheet<FilterResult>(
      context: context,
      backgroundColor: Colors.transparent, // Allows custom rounded corners
      isScrollControlled: true, // Allows sheet to grow with content
      builder: (context) => ExpenseFilterModal(
        allCategories: _allCategories,
        currentCategories: _selectedCategories,
        currentSort: _currentSort,
      ),
    );

    if (result != null) {
      setState(() {
        _selectedCategories = result.selectedCategories;
        _currentSort = result.sortOption;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, 
      body: Column(
        children: [
          // CUSTOM HEADER
          Container(
            padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back Button
                InkWell(
                  onTap: () {
                    if (widget.onBackTap != null) {
                      widget.onBackTap!();
                    } else {
                      Navigator.of(context).maybePop();
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                  ),
                ),
                
                const Text(
                  'All Expenses', 
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  )
                ),

                // 🔥 FILTER BUTTON (Functional Now)
                InkWell(
                  onTap: _openFilterModal,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (_selectedCategories.isNotEmpty || _currentSort != SortOption.newest)
                          ? Colors.white // Highlight if filters active
                          : Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.filter_list_rounded, 
                      color: (_selectedCategories.isNotEmpty || _currentSort != SortOption.newest)
                          ? AppColors.primary 
                          : Colors.white,
                      size: 20
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: StreamBuilder<List<Expense>>(
                stream: getExpenses(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No expenses yet.'));
                  }

                  // 1. GET DATA
                  List<Expense> expenses = snapshot.data!;

                  // 2. APPLY CATEGORY FILTER
                  if (_selectedCategories.isNotEmpty) {
                    expenses = expenses.where((e) => _selectedCategories.contains(e.category)).toList();
                  }

                  // 3. APPLY SORT
                  expenses.sort((a, b) {
                    switch (_currentSort) {
                      case SortOption.newest:
                        return b.date.compareTo(a.date);
                      case SortOption.oldest:
                        return a.date.compareTo(b.date);
                      case SortOption.highestAmount:
                        return b.amount.compareTo(a.amount);
                      case SortOption.lowestAmount:
                        return a.amount.compareTo(b.amount);
                    }
                  });

                  if (expenses.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 48, color: Colors.grey),
                        const SizedBox(height: 10),
                        const Text('No expenses match your filter.'),
                        TextButton(
                          onPressed: () {
                             setState(() {
                               _selectedCategories.clear();
                               _currentSort = SortOption.newest;
                             });
                          }, 
                          child: const Text('Clear Filters', style: TextStyle(color: AppColors.primary))
                        )
                      ],
                    );
                  }

                  return AllExpensesListView(
                    expenses: expenses,
                    onEdit: _editExpense,
                    onDelete: _deleteExpense,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}