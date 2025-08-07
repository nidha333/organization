import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organization/common/constants/app_strings.dart';
import 'package:organization/features/weekly_council/application/providers/weekly_council_provider.dart';
import 'package:organization/features/weekly_council/domain/enums/status_enum.dart';
import 'package:organization/features/weekly_council/domain/enums/week_enum.dart';
import 'package:organization/features/weekly_council/presentation/pages/weekly_council_barchart.dart';
import 'package:organization/features/weekly_council/presentation/pages/weekly_council_flchart.dart';
import 'package:organization/features/weekly_council/presentation/widgets/weekly_form_widget.dart';

class WeeklyCouncilPage extends ConsumerWidget {
  const WeeklyCouncilPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedWeek = ref.watch(selectedWeekFilterProvider);
    final weeklyCouncilResult = ref.watch(weeklyCouncilResultProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.weeklyCouncilTitle),
        backgroundColor: const Color(0xFF2563EB),
        actions: [
          DropdownButton<MonthlyWeeks>(
            value: selectedWeek,
            hint: const Text(AppStrings.filterWeek),
            items: MonthlyWeeks.values.map((week) {
              return DropdownMenuItem(
                value: week,
                child: Text(week.toString()),
              );
            }).toList(),
            onChanged: (value) {
              ref.read(selectedWeekFilterProvider.notifier).state = value;
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showWeeklyBottomSheet(context, ref),
        backgroundColor: const Color(0xFF2563EB),
        child: const Icon(Icons.add),
      ),
      body: weeklyCouncilResult.when(
        data: (data) {
          if (data.isEmpty) {
            return const Center(child: Text(AppStrings.noRecords));
          }

          // Filter by selected week if selected
          final filteredData = selectedWeek != null
              ? data.where((e) => e.week == selectedWeek).toList()
              : data;

          final doneCount = filteredData
              .where((e) => e.status == MeetingStatus.done)
              .length;
          final notDoneCount = filteredData
              .where((e) => e.status == MeetingStatus.notDone)
              .length;
          final noResponseCount = filteredData
              .where((e) => e.status == MeetingStatus.noRsponse)
              .length;

          final validData = filteredData.toList();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // DataTable
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
                            rows: filteredData.map((item) {
                              return DataRow(
                                color: WidgetStateProperty.all(
                                  item.status.color.withOpacity(0.1),
                                ),
                                cells: [
                                  DataCell(Text(item.area)),
                                  DataCell(Text(item.status.value)),
                                  DataCell(Text(item.percentage.toString())),
                                  DataCell(Text(item.year.toString())),
                                  DataCell(Text(item.month.name)),
                                  DataCell(Text(item.week.name)),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Pie Chart
                  PieChartSample3(
                    doneCount: doneCount,
                    notDoneCount: notDoneCount,
                    noResponseCount: noResponseCount,
                  ),

                  const SizedBox(height: 20),

                  // Bar Chart
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SimpleBarChart(
                        areas: validData.map((e) => e.area).toList(),
                        percentages: validData
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

  void _showWeeklyBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return WeeklyFormWidget();
      },
    );
  }
}
