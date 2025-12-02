import 'package:expense_tracker_3_0/models/all_expense_model.dart';
import 'package:expense_tracker_3_0/widgets/form_fields.dart'; 
import 'package:flutter/material.dart';
import '../firestore_functions.dart'; 

// --- (Your FormLabel and RoundedTextField imports are assumed) ---

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
  late String dateLabel;
  // State variables for non-editable data from the expense model
  late int iconCodePoint;
  late int iconColorValue;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.expense.title);
    amountController =
        TextEditingController(text: widget.expense.amount.toString());
    notesController = TextEditingController(text: widget.expense.notes);
    category = widget.expense.category;
    dateLabel = widget.expense.dateLabel;
    iconCodePoint = widget.expense.iconCodePoint;
    iconColorValue = widget.expense.iconColorValue;
  }

  // 🔥 THE FIX: Renamed method to avoid collision with the imported updateExpense function.
  void _handleUpdateExpense() async {
    // Simple validation
    if (nameController.text.trim().isEmpty || amountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Name and Amount are required.')));
      return;
    }
    
    // 1. Create the updated Expense object, preserving the original ID
    final updatedExpense = Expense(
      id: widget.expense.id, // CRITICAL: Keeps the original ID
      title: nameController.text.trim(),
      amount: double.tryParse(amountController.text) ?? 0.0,
      category: category,
      dateLabel: dateLabel,
      notes: notesController.text.trim(),
      iconCodePoint: iconCodePoint,
      iconColorValue: iconColorValue, date: widget.expense.date,
      // You should also pass the 'date' Timestamp here if sorting relies on it
      // For this example, we assume the sorting is just fine without updating the date.
    );

    // 2. Call the globally imported updateExpense function to overwrite the existing document
    await updateExpense(updatedExpense);

    // Close page
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

    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF009846),
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
            GestureDetector(
              onTap: () async {
                final selected = await showDialog<String>(
                  context: context,
                  builder: (ctx) => SimpleDialog(
                    title: const Text('Select category'),
                    children: categories.map((c) => 
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(ctx, c), 
                        child: Text(c)
                      )
                    ).toList(),
                  ),
                );
                if (selected != null) setState(() => category = selected);
              },
              child: RoundedTextField(
                controller: TextEditingController(text: category), 
                hintText: category,
                suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                readOnly: true,
                key: ValueKey(category), 
              ),
            ),
            const SizedBox(height: 16),

            const FormLabel('Date'),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    dateLabel = '${picked.month.toString().padLeft(2,'0')}/${picked.day.toString().padLeft(2,'0')}/${picked.year}';
                  });
                }
              },
              child: RoundedTextField(
                controller: TextEditingController(text: dateLabel),
                hintText: dateLabel,
                suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
                readOnly: true,
                key: ValueKey(dateLabel), 
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
                onPressed: _handleUpdateExpense, // ✅ Calls the corrected local method
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text("Update Expense"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A54C),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}