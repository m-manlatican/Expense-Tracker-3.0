import 'dart:math';
import 'package:flutter/material.dart';

class PieChartData {
  final double value;
  final Color color;
  final String label;

  PieChartData(this.value, this.color, this.label);
}

class SimplePieChart extends StatelessWidget {
  final List<PieChartData> data;
  final double radius;

  const SimplePieChart({super.key, required this.data, this.radius = 100});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: radius * 2,
      width: radius * 2,
      child: CustomPaint(
        painter: _PieChartPainter(data),
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final List<PieChartData> data;

  _PieChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    
    double total = data.fold(0, (sum, item) => sum + item.value);
    double startAngle = -pi / 2; // Start from top

    for (var item in data) {
      final sweepAngle = (item.value / total) * 2 * pi;
      
      final paint = Paint()
        ..color = item.color
        ..style = PaintingStyle.fill;

      // Draw segment
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      // Optional: Draw white separator lines
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
        
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        borderPaint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}