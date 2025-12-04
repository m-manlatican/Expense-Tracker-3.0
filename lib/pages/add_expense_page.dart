import 'package:expense_tracker_3_0/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker_3_0/widgets/form_fields.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  String selectedCategory = 'Food';
  bool isLoading = false;
  
  final List<String> categories = ['Food', 'Transport', 'Shopping', 'Bills', 'Entertainment', 'Health', 'Other'];

  Map<String, dynamic> _getCategoryDetails(String category) {
    switch (category) {
      case 'Food': return {'icon': Icons.fastfood, 'color': const Color(0xFFFF9F0A)}; 
      case 'Transport': return {'icon': Icons.directions_car, 'color': const Color(0xFF0A84FF)}; 
      case 'Shopping': return {'icon': Icons.shopping_bag, 'color': const Color(0xFFBF5AF2)}; 
      case 'Bills': return {'icon': Icons.receipt_long, 'color': const Color(0xFFFF375F)}; 
      case 'Entertainment': return {'icon': Icons.movie, 'color': const Color(0xFF5E5CE6)}; 
      case 'Health': return {'icon': Icons.medical_services, 'color': const Color(0xFF32D74B)}; 
      default: return {'icon': Icons.grid_view, 'color': const Color(0xFF8E8E93)}; 
    }
  }

  Future<void> _saveExpense() async {
    final title = titleController.text.trim();
    final amountText = amountController.text.trim();
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (title.isEmpty || amountText.isEmpty || userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill required fields.')));
      return;
    }

    try {
      setState(() => isLoading = true);

      final double amount = double.parse(amountText);
      final now = DateTime.now(); 
      final categoryDetails = _getCategoryDetails(selectedCategory);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('expenses')
          .add({
        'title': title,
        'amount': amount,
        'category': selectedCategory,
        'notes': notesController.text.trim(),
        'date': Timestamp.now(), 
        'dateLabel': "${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}/${now.year}",
        'iconCodePoint': (categoryDetails['icon'] as IconData).codePoint, 
        'iconColorValue': (categoryDetails['color'] as Color).value,
      });

      if (!mounted) return;
      Navigator.pop(context); 
      
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // No standard AppBar
      body: Column(
        children: [
          // 🔥 CUSTOM HEADER (Exact Match to Reports Page)
          Container(
            padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(12),
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
                      "Add Expense",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 40), // Balance the title
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FormLabel('Expense Name'),
                  const SizedBox(height: 6),
                  RoundedTextField(
                    controller: titleController, 
                    hintText: 'e.g. Lunch at Mcdonalds'
                  ),
                  const SizedBox(height: 16),

                  const FormLabel('Amount'),
                  const SizedBox(height: 6),
                  RoundedTextField(
                    controller: amountController,
                    prefix: const Text('\$', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    hintText: '0.00',
                  ),
                  const SizedBox(height: 16),

                  const FormLabel('Category'),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14), 
                      border: Border.all(color: Colors.grey.shade200), 
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        borderRadius: BorderRadius.circular(14),
                        items: categories.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedCategory = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  const FormLabel('Notes (Optional)'),
                  const SizedBox(height: 6),
                  RoundedTextField(
                    controller: notesController, 
                    hintText: 'Add any additional details...', 
                    maxLines: 3
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : _saveExpense,
                      icon: isLoading 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.check_circle_outline, color: Colors.white),
                      label: Text(
                        isLoading ? "Saving..." : "Save Expense", 
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 4,
                        shadowColor: AppColors.primary.withOpacity(0.4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}