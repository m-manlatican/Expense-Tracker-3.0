import 'package:expense_tracker_3_0/cards/white_card.dart';
import 'package:expense_tracker_3_0/widgets/line_chart_painter.dart';
import 'package:flutter/material.dart';

class SpendingOverviewCard extends StatelessWidget {
  const SpendingOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Simple fake data points for the mini line chart
    const points = [450.0, 200.0, 80.0, 90.0, 140.0, 220.0];

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
          SizedBox(
            height: 140,
            child: CustomPaint(
              painter: LineChartPainter(points),
              child: Container(),
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('11/20', style: TextStyle(fontSize: 10, color: Colors.black45)),
              Text('11/23', style: TextStyle(fontSize: 10, color: Colors.black45)),
              Text('11/25', style: TextStyle(fontSize: 10, color: Colors.black45)),
              Text('11/26', style: TextStyle(fontSize: 10, color: Colors.black45)),
              Text('11/27', style: TextStyle(fontSize: 10, color: Colors.black45)),
              Text('11/28', style: TextStyle(fontSize: 10, color: Colors.black45)),
            ],
          ),
        ],
      ),
    );
  }
}