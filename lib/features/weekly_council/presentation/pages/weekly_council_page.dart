import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organization/common/constants/app_colors.dart';
import 'package:organization/common/constants/app_strings.dart';
import 'package:organization/common/extentions/date_time_extention.dart';
import 'package:organization/features/weekly_council/application/providers/weekly_council_provider.dart';
import 'package:organization/features/weekly_council/domain/enums/meeting_status_enum.dart';
import 'package:organization/features/weekly_council/domain/enums/months_enum.dart';
import 'package:organization/features/weekly_council/domain/enums/week_filtertype.dart';
import 'package:organization/features/weekly_council/domain/enums/weeks_enum.dart';
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
  WeekFilterType selectedFilter = WeekFilterType.thisWeek;

  late FilteringWeekModel selectedWeek;

  @override
  void initState() {
    super.initState();
    selectedWeek = DateTime.now().getThisWeek();
  }

  @override
  Widget build(BuildContext context) {
    final weeklyCouncilResult = ref.watch(weeklyCouncilResultProvider);

    final screenWidth = MediaQuery.of(context).size.width;

    final isNarrowScreen = screenWidth < 900;

    final cardBackgroundColor = const Color(0xFF1E293B);
    final cardPadding = const EdgeInsets.all(20);
    final cardBorderRadius = BorderRadius.circular(16);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 12, 24, 39),
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
            const Text(
              AppStrings.weeklyCouncilTitle,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 36, 46, 62),
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        actions: [_buildWeekToggleButtons()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showWeeklyBottomSheet(context),
        backgroundColor: AppColors.blue3Colors,
        child: Icon(Icons.add, color: AppColors.darkblue1Colors),
      ),
      body: weeklyCouncilResult.when(
        data: (data) {
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
              .where((e) => e.status == MeetingStatus.noRsponse)
              .length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 30),
                isNarrowScreen
                    ? Column(
                        children: [
                          _buildCard(
                            backgroundColor: cardBackgroundColor,
                            borderRadius: cardBorderRadius,
                            padding: cardPadding,
                            child: _buildDataTable(filteredData),
                          ),
                          const SizedBox(height: 20),
                          _buildCard(
                            backgroundColor: cardBackgroundColor,
                            borderRadius: cardBorderRadius,
                            padding: cardPadding,
                            child: SizedBox(
                              height: 300,
                              child: PieChartSample3(
                                doneCount: doneCount,
                                notDoneCount: notDoneCount,
                                noResponseCount: noResponseCount,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildCard(
                            backgroundColor: cardBackgroundColor,
                            borderRadius: cardBorderRadius,
                            padding: cardPadding,
                            child: SimpleBarChart(
                              areas: filteredData.map((e) => e.area).toList(),
                              percentages: filteredData
                                  .map((e) => e.percentage.toDouble())
                                  .toList(),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: _buildCard(
                              backgroundColor: cardBackgroundColor,
                              borderRadius: cardBorderRadius,
                              padding: cardPadding,
                              child: _buildDataTable(filteredData),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 2,
                            child: _buildCard(
                              backgroundColor: cardBackgroundColor,
                              borderRadius: cardBorderRadius,
                              padding: cardPadding,
                              child: SizedBox(
                                height: 300,
                                child: PieChartSample3(
                                  doneCount: doneCount,
                                  notDoneCount: notDoneCount,
                                  noResponseCount: noResponseCount,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 2,
                            child: _buildCard(
                              backgroundColor: cardBackgroundColor,
                              borderRadius: cardBorderRadius,
                              padding: cardPadding,
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
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }

  Widget _buildCard({
    required Widget child,
    required Color backgroundColor,
    required BorderRadius borderRadius,
    required EdgeInsets padding,
  }) {
    return Card(
      color: backgroundColor,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: Padding(padding: padding, child: child),
    );
  }

  Widget _buildWeekToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => setState(() {
            selectedFilter = WeekFilterType.thisWeek;
            selectedWeek = DateTime.now().getThisWeek();
          }),
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedFilter == WeekFilterType.thisWeek
                ? AppColors.blue3Colors
                : AppColors.darkblue2Colors,
          ),
          child: const Text('This Week'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => setState(() {
            selectedFilter = WeekFilterType.lastWeek;
            selectedWeek = DateTime.now().getLastWeek();
          }),
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedFilter == WeekFilterType.lastWeek
                ? AppColors.blue3Colors
                : AppColors.darkblue2Colors,
          ),
          child: const Text('Last Week'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedFilter == WeekFilterType.custom
                ? AppColors.blue3Colors
                : AppColors.darkblue2Colors,
          ),
          onPressed: () {
            selectedFilter = WeekFilterType.custom;
            int dialogSelectedYear = selectedWeek.year;
            MonthsEnum dialogSelectedMonth = selectedWeek.month;
            MonthlyWeeks dialogSelectedWeek = selectedWeek.week;

            final weeks = MonthlyWeeks.values;

            showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setDialogState) {
                    return AlertDialog(
                      title: Row(
                        children: [
                          DropdownButton<int>(
                            value: dialogSelectedYear,
                            items: List.generate(5, (index) {
                              int year = DateTime.now().year - 2 + index;
                              return DropdownMenuItem(
                                value: year,
                                child: Text(year.toString()),
                              );
                            }),
                            onChanged: (year) {
                              if (year != null) {
                                setDialogState(() {
                                  dialogSelectedYear = year;
                                });
                              }
                            },
                          ),
                          const SizedBox(width: 10),
                          DropdownButton<MonthsEnum>(
                            value: dialogSelectedMonth,
                            items: MonthsEnum.values.map((month) {
                              return DropdownMenuItem(
                                value: month,
                                child: Text(month.value),
                              );
                            }).toList(),
                            onChanged: (month) {
                              if (month != null) {
                                setDialogState(() {
                                  dialogSelectedMonth = month;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      content: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(weeks.length, (index) {
                          MonthlyWeeks weekValue = weeks[index];
                          int displayNumber = index + 1;
                          return ElevatedButton(
                            onPressed: () {
                              setDialogState(() {
                                dialogSelectedWeek = weekValue;
                              });

                              Navigator.pop(context);

                              setState(() {
                                selectedWeek = FilteringWeekModel(
                                  year: dialogSelectedYear,
                                  month: dialogSelectedMonth,
                                  week: weekValue,
                                );
                              });
                            },
                            child: Text(displayNumber.toString()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: dialogSelectedWeek == weekValue
                                  ? AppColors.blue3Colors
                                  : AppColors.whiteColors.withValues(
                                      alpha: 0.3,
                                    ),
                            ),
                          );
                        }),
                      ),
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
            );
          },
          child: const Text('Custom'),
        ),
      ],
    );
  }

  Widget _buildDataTable(List filteredData) {
    if (filteredData.isEmpty) {
      return const Text(
        "No records for this week",
        style: TextStyle(color: Colors.white70),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateColor.resolveWith(
            (_) => Colors.blue.shade800,
          ),
          headingTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1,
          ),
          dataRowColor: MaterialStateColor.resolveWith(
            (states) => Colors.transparent,
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
              cells: [
                DataCell(
                  Text(
                    item.area,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                DataCell(
                  Text(
                    item.status.value,
                    style: TextStyle(color: item.status.color),
                  ),
                ),
                DataCell(
                  Text(
                    item.percentage.toString(),
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                DataCell(
                  Text(
                    item.year.toString(),
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                DataCell(
                  Text(
                    item.month.value,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                DataCell(
                  Text(
                    (item.week.index + 1).toString(),
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            );
          }).toList(),
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
