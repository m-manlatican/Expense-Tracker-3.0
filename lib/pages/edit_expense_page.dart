import 'package:expense_tracker_3_0/models/all_expense_model.dart';
import 'package:expense_tracker_3_0/widgets/form_fields.dart';
import 'package:flutter/material.dart';

class EditExpensePage extends StatefulWidget {
  final Expense expense; // the expense to edit

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

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.expense.title);
    amountController =
        TextEditingController(text: widget.expense.amount.toString());
    notesController = TextEditingController(text: widget.expense.notes);
    category = widget.expense.category;
    dateLabel = widget.expense.dateLabel;
  }

  void updateExpense() {
    final updatedData = {
      "id": widget.expense.id, // keep the same id
      "title": nameController.text.trim(),
      "amount": double.tryParse(amountController.text) ?? 0.0,
      "category": category,
      "dateLabel": dateLabel,
      "notes": notesController.text.trim(),
    };

    Navigator.pop(context, updatedData);
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
            RoundedTextField(
              controller: nameController,
              hintText: 'e.g. Office Supplies',
            ),
            const SizedBox(height: 16),

            const FormLabel('Amount'),
            const SizedBox(height: 6),
            RoundedTextField(
              controller: amountController,
              prefix: const Text(
                '\$',
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 16),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
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
                    children: [
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(ctx, 'Supplies'),
                        child: const Text('Supplies'),
                      ),
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(ctx, 'Meals'),
                        child: const Text('Meals'),
                      ),
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(ctx, 'Travel'),
                        child: const Text('Travel'),
                      ),
                      SimpleDialogOption(
                        onPressed: () => Navigator.pop(ctx, 'Software'),
                        child: const Text('Software'),
                      ),
                    ],
                  ),
                );

                if (selected != null) {
                  setState(() => category = selected);
                }
              },
              child: RoundedTextField(
                controller: TextEditingController(text: category),
                hintText: category,
                suffixIcon:
                    const Icon(Icons.keyboard_arrow_down_rounded),
                readOnly: true,
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
                    dateLabel =
                        '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
                  });
                }
              },
              child: RoundedTextField(
                controller: TextEditingController(text: dateLabel),
                hintText: dateLabel,
                suffixIcon: const Icon(Icons.calendar_today_rounded,
                    size: 18),
                readOnly: true,
              ),
            ),
            const SizedBox(height: 16),

            const FormLabel('Notes (Optional)'),
            const SizedBox(height: 6),
            RoundedTextField(
              controller: notesController,
              hintText: 'Add any additional details...',
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: updateExpense,
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text("Update Expense"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A54C),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
