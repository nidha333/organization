import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:organization/features/weekly_council/domain/enums/months_enum.dart';

class GroupedMonthlyBarChart extends StatelessWidget {
  final List<MonthsEnum> monthLabels;
  final List<int> doneCounts;
  final List<int> notDoneCounts;
  final List<int> noResponseCounts;

  const GroupedMonthlyBarChart({
    super.key,
    required this.monthLabels,
    required this.doneCounts,
    required this.notDoneCounts,
    required this.noResponseCounts,
  });

  @override
  Widget build(BuildContext context) {
    final sortedData = _sortMonthsSafe(
      monthLabels: monthLabels,
      doneCounts: doneCounts,
      notDoneCounts: notDoneCounts,
      noResponseCounts: noResponseCounts,
    );

    final barWidth = 40.0;
    final totalBars = sortedData.sortedLabels.length;
    final chartWidth = (totalBars * (barWidth * 3 + 12)) + 40;

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: chartWidth,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: List.generate(sortedData.sortedLabels.length, (
                    index,
                  ) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: sortedData.sortedDone[index].toDouble(),
                          width: barWidth,
                          color: const Color(0xFF70C28C),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        BarChartRodData(
                          toY: sortedData.sortedNotDone[index].toDouble(),
                          width: barWidth,
                          color: const Color(0xFFF87171),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        BarChartRodData(
                          toY: sortedData.sortedNoResponse[index].toDouble(),
                          width: barWidth,
                          color: const Color(0xFF9CA3AF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                      barsSpace: 4,
                    );
                  }),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                        reservedSize: 28,
                      ),
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
                          if (index < 0 ||
                              index >= sortedData.sortedLabels.length) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              sortedData.sortedLabels[index],
                              style: const TextStyle(fontSize: 12),
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
            ),
          ),
        ),
      ],
    );
  }
}

class _SortedMonthlyData {
  final List<String> sortedLabels;
  final List<int> sortedDone;
  final List<int> sortedNotDone;
  final List<int> sortedNoResponse;

  _SortedMonthlyData({
    required this.sortedLabels,
    required this.sortedDone,
    required this.sortedNotDone,
    required this.sortedNoResponse,
  });
}

/// Safe sorting & padding to prevent RangeError
_SortedMonthlyData _sortMonthsSafe({
  required List<MonthsEnum> monthLabels,
  required List<int> doneCounts,
  required List<int> notDoneCounts,
  required List<int> noResponseCounts,
}) {
  List<_MonthDataItem> items = [];

  for (int i = 0; i < monthLabels.length; i++) {
    final monthEnum = monthLabels[i];
    final label = monthEnum.value;
    final monthIndex = monthEnum.index;

    items.add(
      _MonthDataItem(
        label: label,
        done: (i < doneCounts.length) ? doneCounts[i] : 0,
        notDone: (i < notDoneCounts.length) ? notDoneCounts[i] : 0,
        noResponse: (i < noResponseCounts.length) ? noResponseCounts[i] : 0,
        monthIndex: monthIndex,
      ),
    );
  }

  items.sort((a, b) => a.monthIndex.compareTo(b.monthIndex));

  return _SortedMonthlyData(
    sortedLabels: items.map((e) => e.label).toList(),
    sortedDone: items.map((e) => e.done).toList(),
    sortedNotDone: items.map((e) => e.notDone).toList(),
    sortedNoResponse: items.map((e) => e.noResponse).toList(),
  );
}

class _MonthDataItem {
  final String label;
  final int done;
  final int notDone;
  final int noResponse;
  final int monthIndex;

  _MonthDataItem({
    required this.label,
    required this.done,
    required this.notDone,
    required this.noResponse,
    required this.monthIndex,
  });
}
