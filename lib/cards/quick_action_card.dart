import 'package:expense_tracker_3_0/cards/white_card.dart';
import 'package:expense_tracker_3_0/pages/all_expenses_page.dart';
import 'package:flutter/material.dart';

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AllExpensesPage()),
        );
      }, 
      child: WhiteCard(
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFE8FFF6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.format_list_bulleted_sharp,color: Colors.green,size: 20,),
            ),
            SizedBox(width: 20),
            Text('View All Expenses', style: TextStyle(color: Colors.black),)
          ],
        )
      )
    );
  }
}