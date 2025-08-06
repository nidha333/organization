import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartSample3 extends StatefulWidget {
  final int doneCount;
  final int notDoneCount;
  final int noResponseCount;

  const PieChartSample3({
    super.key,
    required this.doneCount,
    required this.notDoneCount,
    required this.noResponseCount,
  });

  @override
  State<PieChartSample3> createState() => _PieChartSample3State();
}

class _PieChartSample3State extends State<PieChartSample3> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (event, response) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    response == null ||
                    response.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex = response.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          borderData: FlBorderData(show: false),
          sectionsSpace: 2,
          centerSpaceRadius: 0,
          sections: showingSections(),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    final total =
        widget.doneCount + widget.notDoneCount + widget.noResponseCount;

    if (total == 0) {
      return [];
    }

    return [
      PieChartSectionData(
        color: const Color.fromARGB(255, 115, 197, 157),
        value: widget.doneCount.toDouble(),
        title: '${((widget.doneCount / total) * 100).toInt()}%',
        radius: touchedIndex == 0 ? 110 : 100,
        titleStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      PieChartSectionData(
        color: const Color.fromARGB(255, 238, 128, 128),
        value: widget.notDoneCount.toDouble(),
        title: '${((widget.notDoneCount / total) * 100).toInt()}%',
        radius: touchedIndex == 1 ? 110 : 100,
        titleStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      PieChartSectionData(
        color: const Color.fromARGB(255, 170, 168, 168),
        value: widget.noResponseCount.toDouble(),
        title: '${((widget.noResponseCount / total) * 100).toInt()}%',
        radius: touchedIndex == 2 ? 110 : 100,
        titleStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    ];
  }
}
