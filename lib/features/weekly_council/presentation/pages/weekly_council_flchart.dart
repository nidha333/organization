import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartSample3 extends StatefulWidget {
  final int doneCount;
  final int notDoneCount;
  final int noResponseCount;

  const PieChartSample3({
    Key? key,
    required this.doneCount,
    required this.notDoneCount,
    required this.noResponseCount,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChartSample3State();
}

class PieChartSample3State extends State<PieChartSample3> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final total =
        widget.doneCount + widget.notDoneCount + widget.noResponseCount;

    return AspectRatio(
      aspectRatio: 1.9,
      child: Column(
        children: <Widget>[
          const Text(
            'Current Week Status',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          Expanded(
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (event, response) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            response == null ||
                            response.touchedSection == null) {
                          touchedIndex = -1;
                        } else {
                          touchedIndex =
                              response.touchedSection!.touchedSectionIndex;
                        }
                      });
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: showingSections(),
              ),
            ),
          ),

          // Add legend
          Wrap(
            spacing: 12,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: [
              legendItem(Colors.green, 'Done (${widget.doneCount})'),
              legendItem(Colors.red, 'Not Done (${widget.notDoneCount})'),
              legendItem(
                Colors.grey,
                'No Response (${widget.noResponseCount})',
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    final total =
        widget.doneCount + widget.notDoneCount + widget.noResponseCount;

    if (total == 0) {
      return [
        PieChartSectionData(
          color: Colors.grey[300],
          value: 1,
          title: 'No Data',
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ];
    }

    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final double radius = isTouched ? 70 : 60;
      double percentage = 0;
      Color color;
      String label;

      switch (i) {
        case 0:
          percentage = (widget.doneCount / total) * 100;
          color = Colors.green;
          label = '${percentage.toStringAsFixed(1)}%';
          break;
        case 1:
          percentage = (widget.notDoneCount / total) * 100;
          color = Colors.red;
          label = '${percentage.toStringAsFixed(1)}%';
          break;
        case 2:
          percentage = (widget.noResponseCount / total) * 100;
          color = Colors.grey;
          label = '${percentage.toStringAsFixed(1)}%';
          break;
        default:
          color = Colors.transparent;
          label = '';
      }

      return PieChartSectionData(
        color: color,
        value: percentage,
        title: label,
        radius: radius,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  Widget legendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
