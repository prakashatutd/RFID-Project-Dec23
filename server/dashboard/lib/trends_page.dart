import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TrendsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trends'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'product') {
                // Handle Product Page option
              } else if (value == 'history') {
                // Handle Scan History option
              } else if (value == 'trends') {
                // Handle Trends option
              } else if (value == 'orders') {
                // Handle Orders Page option
              }
            },
            itemBuilder: (BuildContext context) {
              return {
                'Product Page',
                'Scan History',
                'Trends',
                'Orders Page',
              }.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        height: 500,
        child: LineChart(
          LineChartData(borderData: FlBorderData(show: false), lineBarsData: [
            LineChartBarData(spots: [
              const FlSpot(0, 1),
              const FlSpot(1, 3),
              const FlSpot(2, 10),
              const FlSpot(3, 7),
              const FlSpot(4, 12),
              const FlSpot(5, 13),
              const FlSpot(6, 17),
              const FlSpot(7, 15),
              const FlSpot(8, 20)
            ])
          ]),
        ),
        ),
      ),
    );
  }
}
