import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GroupedWeeklyBarChart extends StatelessWidget {
  final List<String> weekLabels;
  final List<int> doneCounts;
  final List<int> notDoneCounts;
  final List<int> noResponseCounts;

  const GroupedWeeklyBarChart({
    super.key,
    required this.weekLabels,
    required this.doneCounts,
    required this.notDoneCounts,
    required this.noResponseCounts,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: List.generate(weekLabels.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: doneCounts[index].toDouble(),
                  width: 40,
                  color: const Color(0xFF70C28C),
                  borderRadius: BorderRadius.circular(4),
                ),
                BarChartRodData(
                  toY: notDoneCounts[index].toDouble(),
                  width: 40,
                  color: const Color(0xFFF87171),
                  borderRadius: BorderRadius.circular(4),
                ),
                BarChartRodData(
                  toY: noResponseCounts[index].toDouble(),
                  width: 40,
                  color: const Color(0xFF9CA3AF),
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
              barsSpace: 2,
            );
          }),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= weekLabels.length) {
                    return const SizedBox();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      weekLabels[index],
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: true),
        ),
      ),
    );
  }
}
