import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  
  // Categories list
  final List<String> categories = ['Food', 'Transport', 'Shopping', 'Bills', 'Entertainment', 'Health', 'Other'];

  Future<void> _saveExpense() async {
  final title = titleController.text.trim();
  final amountText = amountController.text.trim();
  final userId = FirebaseAuth.instance.currentUser?.uid;

  if (title.isEmpty || amountText.isEmpty || userId == null) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill required fields and ensure you are logged in.')));
    return;
  }

  try {
    setState(() => isLoading = true);

    final double amount = double.parse(amountText);

    // --- CRITICAL SAVING PATH ---
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .add({
      'title': title,
      'amount': amount,
      'category': selectedCategory,
      'notes': notesController.text.trim(),
      'date': Timestamp.now(), // Use Timestamp for correct sorting
      'dateLabel': "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      'iconCodePoint': Icons.fastfood.codePoint, 
      'iconColorValue': Colors.blue.value,
    });

    if (!mounted) return;
    Navigator.pop(context); // Go back to Dashboard after saving
    
  } on FirebaseException catch (e) {
    // 🔥 New: Log the specific Firebase error code and message
    debugPrint('Firebase Save Error Code: ${e.code}');
    debugPrint('Firebase Save Error Message: ${e.message}');
    
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Save failed: ${e.message} (Code: ${e.code})'),
            backgroundColor: Colors.red,
        )
    );
  } catch (e) {
    // Handle generic errors (like parsing amount)
    debugPrint('General Save Error: $e');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('General Error: $e'),
            backgroundColor: Colors.red,
        )
    );
  } finally {
    if (mounted) setState(() => isLoading = false);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add Expense"),
        backgroundColor: const Color(0xFF0AA06E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Amount", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: "0.00",
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            const Text("Title", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: "e.g. Lunch at Mcdonalds",
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            const Text("Category", style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCategory,
                  isExpanded: true,
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

            const Text("Notes (Optional)", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Additional details...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _saveExpense,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0AA06E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text("Save Expense"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}