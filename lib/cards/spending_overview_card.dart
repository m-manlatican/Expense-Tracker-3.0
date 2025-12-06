import 'package:expense_tracker_3_0/cards/white_card.dart';
import 'package:expense_tracker_3_0/widgets/line_chart_painter.dart';
import 'package:flutter/material.dart';

class SpendingOverviewCard extends StatelessWidget {
  final List<double> spendingPoints;
  final List<String> dateLabels;

  const SpendingOverviewCard({
    super.key,
    required this.spendingPoints,
    required this.dateLabels,
  });

  @override
  Widget build(BuildContext context) {
    final points = spendingPoints.isEmpty ? [0.0, 0.0] : spendingPoints;
    
    // Calculate simple growth metric (Last vs First day)
    final double growth = points.last - points.first;
    final bool isUp = growth >= 0;

    return WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sales Trend', // 🔥 Renamed
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              // Simple Trend Indicator
              Row(
                children: [
                  Icon(
                    isUp ? Icons.trending_up : Icons.trending_down, 
                    size: 18, 
                    color: isUp ? Colors.green : Colors.red
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Last 7 Days",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: CustomPaint(
              painter: LineChartPainter(points),
              child: Container(),
            ),
          ),
          const SizedBox(height: 8),
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