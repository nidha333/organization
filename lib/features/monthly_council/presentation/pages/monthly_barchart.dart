import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MonthlyBarchart extends StatelessWidget {
  final List<String> areas;
  final List<double> participation;

  const MonthlyBarchart({
    super.key,
    required this.areas,
    required this.participation,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      width: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'Current Paticipation',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barGroups: List.generate(
                  areas.length,
                  (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: participation[index],
                        width: 40,
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),

                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= areas.length) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            areas[index],
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Show grid lines
                gridData: FlGridData(show: true),

                // Show border around chart
                borderData: FlBorderData(show: true),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
