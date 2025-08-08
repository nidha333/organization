import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organization/common/constants/app_strings.dart';
import 'package:organization/common/data/months.dart';
import 'package:organization/common/extentions/date_time_extention.dart';
import 'package:organization/features/weekly_council/application/providers/weekly_council_provider.dart';
import 'package:organization/features/weekly_council/domain/enums/meeting_status_enum.dart';
import 'package:organization/features/weekly_council/domain/enums/months_enum.dart';
import 'package:organization/features/weekly_council/domain/model/filtering_week_model.dart';
import 'package:organization/features/weekly_council/presentation/pages/weekly_council_barchart.dart';
import 'package:organization/features/weekly_council/presentation/pages/weekly_council_flchart.dart';
import 'package:organization/features/weekly_council/presentation/widgets/weekly_form_widget.dart';

class WeeklyCouncilPage extends ConsumerStatefulWidget {
  const WeeklyCouncilPage({super.key});

  @override
  ConsumerState<WeeklyCouncilPage> createState() => _WeeklyCouncilPageState();
}

class _WeeklyCouncilPageState extends ConsumerState<WeeklyCouncilPage> {
  late FilteringWeekModel selectedWeek;
  late FilteringWeekModel thisWeek;
  late FilteringWeekModel lastWeek;
  MonthsEnum? selectedMonth;

  @override
  void initState() {
    super.initState();
    thisWeek = DateTime.now().getThisWeek();
    lastWeek = DateTime.now().getLastWeek();
    selectedWeek = thisWeek;
  }

  @override
  Widget build(BuildContext context) {
    final weeklyCouncilResult = ref.watch(weeklyCouncilResultProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.weeklyCouncilTitle),
        backgroundColor: const Color(0xFF2563EB),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showWeeklyBottomSheet(context),
        backgroundColor: const Color(0xFF2563EB),
        child: const Icon(Icons.add),
      ),
      body: weeklyCouncilResult.when(
        data: (data) {
          print(selectedWeek.year);
          print(selectedWeek.month);
          print(selectedWeek.week);
          final filteredData = data
              .where(
                (e) =>
                    e.year == selectedWeek.year &&
                    e.month == selectedWeek.month &&
                    e.week == selectedWeek.week,
              )
              .toList();
          print(filteredData);

          final doneCount = filteredData
              .where((e) => e.status == MeetingStatus.done)
              .length;
          final notDoneCount = filteredData
              .where((e) => e.status == MeetingStatus.notDone)
              .length;
          final noResponseCount = filteredData
              .where((e) => e.status == MeetingStatus.noRsponse)
              .length;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildWeekToggleButtons(),
                  const SizedBox(height: 20),
                  _buildDataTable(filteredData),
                  const SizedBox(height: 20),
                  PieChartSample3(
                    doneCount: doneCount,
                    notDoneCount: notDoneCount,
                    noResponseCount: noResponseCount,
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SimpleBarChart(
                        areas: filteredData.map((e) => e.area).toList(),
                        percentages: filteredData
                            .map((e) => e.percentage.toDouble())
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }

  Widget _buildWeekToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => setState(() => selectedWeek = thisWeek),
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedWeek == thisWeek
                ? const Color(0xFF2563EB)
                : Colors.grey.shade300,
          ),
          child: const Text('This Week'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => setState(() => selectedWeek = lastWeek),
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedWeek == lastWeek
                ? const Color(0xFF2563EB)
                : Colors.grey.shade300,
          ),
          child: const Text('Last Week'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: Text(DateTime.now().year.toString()),
                      ),
                      DropdownButton<MonthsEnum>(
                        value: selectedMonth,
                        hint: const Text('Select Month'),
                        items: MonthsEnum.values.map((month) {
                          return DropdownMenuItem<MonthsEnum>(
                            value: month,
                            child: Text(month.value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedMonth = value;
                          });
                        },
                      ),
                    ],
                  ),
                  content: const Text('hhh'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(),
          child: const Text('Custom'),
        ),
      ],
    );
  }

  Widget _buildDataTable(List filteredData) {
    if (filteredData.isEmpty) {
      log(thisWeek.toString());
      return const Text("No records for this week");
    }

    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateColor.resolveWith(
              (_) => Colors.blue.shade100,
            ),
            headingTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            columns: const [
              DataColumn(label: Text(AppStrings.area)),
              DataColumn(label: Text(AppStrings.status)),
              DataColumn(label: Text(AppStrings.percentage)),
              DataColumn(label: Text(AppStrings.year)),
              DataColumn(label: Text(AppStrings.month)),
              DataColumn(label: Text(AppStrings.week)),
            ],
            rows: filteredData.map<DataRow>((item) {
              return DataRow(
                color: WidgetStateProperty.all(
                  item.status.color.withOpacity(0.13),
                ),
                cells: [
                  DataCell(Text(item.area)),
                  DataCell(Text(item.status.value)),
                  DataCell(Text(item.percentage.toString())),
                  DataCell(Text(item.year.toString())),
                  DataCell(Text(item.month.toString())),
                  DataCell(Text(item.week.toString())),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showWeeklyBottomSheet(BuildContext context) async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => WeeklyFormWidget(
        initialYear: selectedWeek.year,
        initialMonth: selectedWeek.month,
        initialWeek: selectedWeek.week,
      ),
    );
  }
}
