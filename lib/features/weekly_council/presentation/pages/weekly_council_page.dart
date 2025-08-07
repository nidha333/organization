import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organization/common/constants/app_strings.dart';
import 'package:organization/common/extentions/date_time_extention.dart';
import 'package:organization/features/weekly_council/application/providers/weekly_council_provider.dart';
import 'package:organization/features/weekly_council/domain/enums/meeting_status_enum.dart';
import 'package:organization/features/weekly_council/domain/enums/week_filtertype.dart';
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

  @override
  void initState() {
    selectedWeek = DateTime.now().getThisWeek();
    super.initState();
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
          final filteredData = data
              .where(
                (e) =>
                    e.year == selectedWeek.year &&
                    e.month == selectedWeek.month &&
                    e.week == selectedWeek.week,
              )
              .toList();

          final doneCount = filteredData
              .where((e) => e.status == MeetingStatus.done)
              .length;
          final notDoneCount = filteredData
              .where((e) => e.status == MeetingStatus.notDone)
              .length;
          final noResponseCount = filteredData
              .where((e) => e.status == MeetingStatus.noRsponse) // Fixed typo
              .length;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildWeekFilterDropdown(ref),
                  const SizedBox(height: 20),
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
                                  item.status.color.withValues(alpha: 0.1),
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
                  const SizedBox(height: 20),
                  _buildWeekFilterDropdown(ref),
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

  Widget _buildWeekFilterDropdown(WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        DropdownButton<FilteringWeekModel>(
          value: selectedWeek,
          onChanged: (FilteringWeekModel? newValue) {
            if (newValue != null) {}
          },
          items: [
            DropdownMenuItem(
              child: Text('This Week'),
              onTap: () {
                setState(() {
                  selectedWeek = DateTime.now().getThisWeek();
                });
              },
            ),
            DropdownMenuItem(
              child: Text('Last Week'),
              onTap: () {
                setState(() {
                  selectedWeek = DateTime.now().getLastWeek();
                });
              },
            ),
            DropdownMenuItem(
              child: Text('Custom'),
              onTap: () {
                // TODO : show WeekSelectionDialog
                // get the custom week model
                // apply to filteringModel sate variable inside setState
              },
            ),
          ],
        ),
      ],
    );
  }

  void _showWeeklyBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => WeeklyFormWidget(),
    );
  }
}
