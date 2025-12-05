import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker_3_0/app_colors.dart';
import 'package:expense_tracker_3_0/models/all_expense_model.dart';
import 'package:expense_tracker_3_0/services/firestore_service.dart';
import 'package:expense_tracker_3_0/widgets/form_fields.dart'; 
import 'package:flutter/material.dart';

class EditExpensePage extends StatefulWidget {
  final Expense expense;
  const EditExpensePage({super.key, required this.expense});

  @override
  State<EditExpensePage> createState() => _EditExpensePageState();
}

class _EditExpensePageState extends State<EditExpensePage> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController qtyController;
  late TextEditingController notesController;
  late TextEditingController amountController; // Unused for Price*Qty logic but kept for structure
  
  late String category;
  late bool isIncome;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.expense.title);
    notesController = TextEditingController(text: widget.expense.notes);
    category = widget.expense.category;
    isIncome = widget.expense.isIncome;
    amountController = TextEditingController();

    // 🔥 LOGIC: Populate Qty only if it exists
    if (widget.expense.quantity != null) {
      qtyController = TextEditingController(text: widget.expense.quantity.toString());
      // Price = Total / Qty
      double price = widget.expense.amount / widget.expense.quantity!;
      priceController = TextEditingController(text: price.toStringAsFixed(2));
    } else {
      // If Quantity was null (user left it empty), leave it empty here too.
      qtyController = TextEditingController(); 
      // Price = Total Amount
      priceController = TextEditingController(text: widget.expense.amount.toStringAsFixed(2));
    }
  }

  void _handleUpdateExpense() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Name is required.')));
      return;
    }

    final price = double.tryParse(priceController.text);
    final qtyString = qtyController.text.trim();
    int? finalQty;

    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Valid Price required.')));
      return;
    }

    // Check optional Qty
    if (qtyString.isNotEmpty) {
      finalQty = int.tryParse(qtyString);
      if (finalQty == null || finalQty <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quantity must be a valid number.')));
        return;
      }
    } else {
      finalQty = null; // Remains null
    }

    final double finalAmount = price * (finalQty ?? 1);
    final now = DateTime.now(); 
    final categoryDetails = Expense.getCategoryDetails(category);

    final updatedExpense = Expense(
      id: widget.expense.id, 
      title: nameController.text.trim(),
      amount: finalAmount,
      quantity: finalQty, // 🔥 Save Qty (null or value)
      category: category,
      dateLabel: "${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}/${now.year}",
      date: Timestamp.fromDate(now),
      notes: notesController.text.trim(),
      iconCodePoint: (categoryDetails['icon'] as IconData).codePoint,
      iconColorValue: (categoryDetails['color'] as Color).value,
      isIncome: isIncome,
      isDeleted: widget.expense.isDeleted,
      isCapital: widget.expense.isCapital,
    );

    await _firestoreService.updateExpense(updatedExpense);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> displayCategories = isIncome 
        ? List.from(Expense.incomeCategories) 
        : List.from(Expense.expenseCategories);

    if (!displayCategories.contains(category)) {
      displayCategories.add(category);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
            decoration: const BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
            child: Row(
              children: [
                InkWell(onTap: () => Navigator.pop(context), child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.arrow_back, color: Colors.white, size: 20))),
                const Expanded(child: Center(child: Text("Edit Record", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)))),
                const SizedBox(width: 40),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FormLabel('Description'), const SizedBox(height: 6), RoundedTextField(controller: nameController, hintText: 'e.g. Office Supplies', textInputAction: TextInputAction.next), const SizedBox(height: 16),
                  
                  // 🔥 UNIFIED INPUTS
                  Row(
                    children: [
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const FormLabel('Price'), const SizedBox(height: 6),
                        RoundedTextField(controller: priceController, prefix: const Text('₱', style: TextStyle(fontWeight: FontWeight.w600)), keyboardType: TextInputType.number),
                      ])),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const FormLabel('Qty (Optional)'), const SizedBox(height: 6),
                        RoundedTextField(controller: qtyController, keyboardType: TextInputType.number, hintText: '1'),
                      ])),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const FormLabel('Category'), const SizedBox(height: 6),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade200)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: category, isExpanded: true, icon: const Icon(Icons.keyboard_arrow_down_rounded), borderRadius: BorderRadius.circular(14), items: displayCategories.map((String value) => DropdownMenuItem(value: value, child: Text(value))).toList(), onChanged: (newValue) => setState(() => category = newValue!)))), const SizedBox(height: 16),
                  const FormLabel('Notes (Optional)'), const SizedBox(height: 6), RoundedTextField(controller: notesController, hintText: 'Add details...', maxLines: 3), const SizedBox(height: 24),
                  SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: _handleUpdateExpense, icon: const Icon(Icons.save, color: Colors.white), label: const Text("Update Record", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 4)))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}