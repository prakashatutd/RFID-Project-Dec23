import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TrendsPage extends StatelessWidget {
  const TrendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          borderData: FlBorderData(show: false), 
          lineBarsData: [
            LineChartBarData(spots: [
              const FlSpot(0, 1),
              const FlSpot(1, 3),
              const FlSpot(2, 10),
              const FlSpot(3, 7),
              const FlSpot(4, 12),
              const FlSpot(10, 13),
            ], color: Colors.blue,),
            LineChartBarData(spots: [
              const FlSpot(0, 1),
              const FlSpot(2, 2),
              const FlSpot(5, 15),
              const FlSpot(10, 20)
            ], color: Colors.red),
            LineChartBarData(spots: [
              const FlSpot(0, 0),
              const FlSpot(4, 5),
              const FlSpot(5, 5),
              const FlSpot(10, 1)
            ], color: Colors.green),
          ]
        ),
      ),
    );
  }
}
