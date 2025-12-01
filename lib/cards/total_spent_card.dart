import 'package:expense_tracker_3_0/cards/white_card.dart';
import 'package:flutter/material.dart';

class TotalSpentCard extends StatelessWidget {
  const TotalSpentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEEF0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Color(0xFFFF4E6A),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Total Spent',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            '\$2000.00',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: LinearProgressIndicator(
              minHeight: 6,
              value: 0.191,
              backgroundColor: const Color(0xFFE9EDF5),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00C665)),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            '19.1% of \$5000.00 budget',
            style: TextStyle(
              fontSize: 11,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}