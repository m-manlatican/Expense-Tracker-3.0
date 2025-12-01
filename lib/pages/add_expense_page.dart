import 'package:expense_tracker_3_0/pages/dashboard_page.dart';
import 'package:flutter/material.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  final notesController = TextEditingController();

  String category = "Supplies"; // default
  String dateLabel = "01/12/2025";

  void saveExpense() {
    final expenseData = {
      "title": nameController.text.trim(),
      "amount": double.tryParse(amountController.text) ?? 0.0,
      "category": category,
      "dateLabel": dateLabel,
      "notes": notesController.text.trim(),
    };

    // RETURN the expense data to the previous page
    Navigator.pop(context, expenseData);
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
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: Container(
          width: 320,
          margin: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(24),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top green header
                Container(
                  height: 72,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF009846), Color(0xFF007D33)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Add Expense',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const DashboardPage()),
                                );
                              },
                              icon: const Icon(
                                Icons.close,
                                size: 18,
                                color: Colors.white,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),

                // Scrollable form area
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _Label('Expense Name'),
                        const SizedBox(height: 6),
                        _RoundedField(
                          controller: nameController,
                          hintText: 'e.g. Office Supplies',
                        ),
                        const SizedBox(height: 16),

                        const _Label('Amount'),
                        const SizedBox(height: 6),
                        _RoundedField(
                          controller: amountController,
                          prefix: const Text(
                            '\$',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          hintText: '0.00',
                        ),
                        const SizedBox(height: 16),

                        const _Label('Category'),
                        const SizedBox(height: 6),
                        // simple tappable category field (expand later to dropdown)
                        GestureDetector(
                          onTap: () async {
                            // example: simple category picker dialog
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
                          child: _RoundedField(
                            controller: TextEditingController(text: category),
                            hintText: category,
                            suffixIcon:
                                const Icon(Icons.keyboard_arrow_down_rounded),
                            readOnly: true,
                          ),
                        ),
                        const SizedBox(height: 16),

                        const _Label('Date'),
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
                          child: _RoundedField(
                            controller: TextEditingController(text: dateLabel),
                            hintText: dateLabel,
                            suffixIcon: const Icon(Icons.calendar_today_rounded,
                                size: 18),
                            readOnly: true,
                          ),
                        ),
                        const SizedBox(height: 16),

                        const _Label('Notes (Optional)'),
                        const SizedBox(height: 6),
                        _RoundedField(
                          controller: notesController,
                          hintText: 'Add any additional details...',
                          maxLines: 3,
                        ),
                        const SizedBox(height: 24),

                        // Save button (calls saveExpense which pops with data)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: saveExpense,
                            icon: const Icon(Icons.save, color: Colors.white),
                            label: const Text("Save Expense"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00A54C),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF555555),
      ),
    );
  }
}

class _RoundedField extends StatelessWidget {
  final String? hintText;
  final Widget? prefix;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool readOnly;
  final int maxLines;
  final TextEditingController? controller;

  const _RoundedField({
    this.hintText,
    this.prefix,
    this.suffixIcon,
    this.keyboardType,
    this.readOnly = false,
    this.maxLines = 1,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        prefixIcon: prefix == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(left: 14, right: 8),
                child: prefix,
              ),
        prefixIconConstraints:
            const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: suffixIcon,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: Color(0xFF00A54C), width: 1.2),
        ),
      ),
    );
  }
}
