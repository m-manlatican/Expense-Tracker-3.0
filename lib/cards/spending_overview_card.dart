import 'package:expense_tracker_3_0/cards/white_card.dart';
import 'package:expense_tracker_3_0/widgets/line_chart_painter.dart';
import 'package:flutter/material.dart';

class SpendingOverviewCard extends StatelessWidget {
  // 1. Accept dynamic data
  final List<double> spendingPoints;
  final List<String> dateLabels;

  const SpendingOverviewCard({
    super.key,
    required this.spendingPoints,
    required this.dateLabels,
  });

  @override
  Widget build(BuildContext context) {
    // Safety check: if empty, show a flat line
    final points = spendingPoints.isEmpty ? [0.0, 0.0] : spendingPoints;

    return WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Spending Overview',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          // 2. Pass real points to the painter
          SizedBox(
            height: 140,
            child: CustomPaint(
              painter: LineChartPainter(points),
              child: Container(),
            ),
          ),
          const SizedBox(height: 8),
          // 3. Generate date labels dynamically
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: dateLabels.map((label) => Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.black45),
            )).toList(),
          ),
        ],
      ),
    );
  }
}