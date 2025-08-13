import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:organization/features/weekly_council/domain/enums/months_enum.dart';

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
    final sortedData = sortByMonthOrder(
      weekLabels: weekLabels,
      doneCounts: doneCounts,
      notDoneCounts: notDoneCounts,
      noResponseCounts: noResponseCounts,
    );

    return SizedBox(
      height: 300,
      width: double.infinity,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: List.generate(sortedData.sortedLabels.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: sortedData.sortedDone[index].toDouble(),
                  width: 40,
                  color: const Color(0xFF70C28C),
                  borderRadius: BorderRadius.circular(4),
                ),
                BarChartRodData(
                  toY: sortedData.sortedNotDone[index].toDouble(),
                  width: 40,
                  color: const Color(0xFFF87171),
                  borderRadius: BorderRadius.circular(4),
                ),
                BarChartRodData(
                  toY: sortedData.sortedNoResponse[index].toDouble(),
                  width: 40,
                  color: const Color(0xFF9CA3AF),
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
              barsSpace: 4,
            );
          }),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false, reservedSize: 28),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= sortedData.sortedLabels.length) {
                    return const SizedBox();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      sortedData.sortedLabels[index],
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
                reservedSize: 40,
              ),
            ),
          ),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: true),
          barTouchData: BarTouchData(enabled: true),
        ),
      ),
    );
  }
}

class SortedWeekData {
  final List<String> sortedLabels;
  final List<int> sortedDone;
  final List<int> sortedNotDone;
  final List<int> sortedNoResponse;

  SortedWeekData({
    required this.sortedLabels,
    required this.sortedDone,
    required this.sortedNotDone,
    required this.sortedNoResponse,
  });
}

class _WeekDataItem {
  final String label;
  final int done;
  final int notDone;
  final int noResponse;
  final int monthIndex;
  final int weekNumber;

  _WeekDataItem({
    required this.label,
    required this.done,
    required this.notDone,
    required this.noResponse,
    required this.monthIndex,
    required this.weekNumber,
  });
}

SortedWeekData sortByMonthOrder({
  required List<String> weekLabels,
  required List<int> doneCounts,
  required List<int> notDoneCounts,
  required List<int> noResponseCounts,
}) {
  List<_WeekDataItem> pairedData = [];

  for (int i = 0; i < weekLabels.length; i++) {
    final label = weekLabels[i];
    final monthStr = label.split(' ').first;

    final monthIndex = MonthsEnum.values.indexWhere(
      (m) => m.value.toLowerCase() == monthStr.toLowerCase(),
    );

    final weekNumber = _extractWeekNumber(label);

    pairedData.add(
      _WeekDataItem(
        label: label,
        done: doneCounts[i],
        notDone: notDoneCounts[i],
        noResponse: noResponseCounts[i],
        monthIndex: monthIndex >= 0 ? monthIndex : 0,
        weekNumber: weekNumber,
      ),
    );
  }

  pairedData.sort((a, b) {
    if (a.monthIndex != b.monthIndex) {
      return a.monthIndex.compareTo(b.monthIndex);
    }
    return a.weekNumber.compareTo(b.weekNumber);
  });

  return SortedWeekData(
    sortedLabels: pairedData.map((e) => e.label).toList(),
    sortedDone: pairedData.map((e) => e.done).toList(),
    sortedNotDone: pairedData.map((e) => e.notDone).toList(),
    sortedNoResponse: pairedData.map((e) => e.noResponse).toList(),
  );
}

int _extractWeekNumber(String label) {
  final parts = label.split(' ');
  if (parts.length < 2) return 0;
  final weekPart = parts[1].toLowerCase();
  final weekNumStr = weekPart.replaceAll(RegExp(r'[^0-9]'), '');
  return int.tryParse(weekNumStr) ?? 0;
}
