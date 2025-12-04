import 'package:expense_tracker_3_0/models/all_expense_model.dart';
import 'package:expense_tracker_3_0/widgets/form_fields.dart'; 
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import '../firestore_functions.dart'; 

class EditExpensePage extends StatefulWidget {
  final Expense expense;

  const EditExpensePage({super.key, required this.expense});

  @override
  State<EditExpensePage> createState() => _EditExpensePageState();
}

class _EditExpensePageState extends State<EditExpensePage> {
  late TextEditingController nameController;
  late TextEditingController amountController;
  late TextEditingController notesController;

  late String category;

  // UNIFIED THEME COLORS
  final Color primaryGreen = const Color(0xFF0AA06E);
  final Color scaffoldBg = const Color(0xFFF3F5F9);

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.expense.title);
    amountController =
        TextEditingController(text: widget.expense.amount.toString());
    notesController = TextEditingController(text: widget.expense.notes);
    category = widget.expense.category;
  }

  Map<String, dynamic> _getCategoryDetails(String category) {
    switch (category) {
      case 'Food':
        return {'icon': Icons.fastfood, 'color': const Color(0xFFFF9F0A)};
      case 'Transport':
        return {'icon': Icons.directions_car, 'color': const Color(0xFF0A84FF)};
      case 'Shopping':
        return {'icon': Icons.shopping_bag, 'color': const Color(0xFFBF5AF2)};
      case 'Bills':
        return {'icon': Icons.receipt_long, 'color': const Color(0xFFFF375F)};
      case 'Entertainment':
        return {'icon': Icons.movie, 'color': const Color(0xFF5E5CE6)};
      case 'Health':
        return {'icon': Icons.medical_services, 'color': const Color(0xFF32D74B)};
      default:
        return {'icon': Icons.grid_view, 'color': const Color(0xFF8E8E93)};
    }
  }

  void _handleUpdateExpense() async {
    if (nameController.text.trim().isEmpty || amountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Name and Amount are required.')));
      return;
    }

    final now = DateTime.now(); 
    final newDateLabel = "${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}/${now.year}";
    
    final categoryDetails = _getCategoryDetails(category);

    final updatedExpense = Expense(
      id: widget.expense.id, 
      title: nameController.text.trim(),
      amount: double.tryParse(amountController.text) ?? 0.0,
      category: category,
      dateLabel: newDateLabel,
      date: Timestamp.fromDate(now),
      notes: notesController.text.trim(),
      iconCodePoint: (categoryDetails['icon'] as IconData).codePoint,
      iconColorValue: (categoryDetails['color'] as Color).value, 
    );

    await updateExpense(updatedExpense);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> categories = ['Supplies', 'Meals', 'Travel', 'Software', 'Food', 'Transport', 'Bills', 'Entertainment', 'Health', 'Other'];

    if (!categories.contains(category)) {
      categories.add(category);
    }

    return Scaffold(
      backgroundColor: scaffoldBg, // Unified Background
      appBar: AppBar(
        // LOCATION 1: The AppBar Color
        backgroundColor: primaryGreen, // Unified Green
        elevation: 0,
        title: const Text(
          'Edit Expense',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FormLabel('Expense Name'),
            const SizedBox(height: 6),
            RoundedTextField(controller: nameController, hintText: 'e.g. Office Supplies'),
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
                borderRadius: BorderRadius.circular(14), // Updated to match Add Page
                border: Border.all(color: Colors.transparent), 
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: category,
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
                      category = newValue!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            const FormLabel('Notes (Optional)'),
            const SizedBox(height: 6),
            RoundedTextField(controller: notesController, hintText: 'Add any additional details...', maxLines: 3),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _handleUpdateExpense,
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text("Update Expense", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  // LOCATION 2: The Button Color
                  backgroundColor: primaryGreen, // Unified Green
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), // Updated radius
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}