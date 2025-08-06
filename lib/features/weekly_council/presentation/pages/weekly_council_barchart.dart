import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SimpleBarChart extends StatelessWidget {
  final List<String> areas;
  final List<double> percentages;

  const SimpleBarChart({
    super.key,
    required this.areas,
    required this.percentages,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: 500,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: List.generate(
            areas.length,
            (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: percentages[index],
                  width: 40,
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.blue,
                ),
              ],
            ),
          ),

          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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

          //  Remove grid lines
          gridData: FlGridData(show: true),

          //  Remove border around chart
          borderData: FlBorderData(show: true),
        ),
      ),
    );
  }
}
