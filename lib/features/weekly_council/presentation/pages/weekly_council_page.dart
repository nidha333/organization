import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organization/common/constants/app_colors.dart';
import 'package:organization/common/extentions/date_time_extention.dart';
import 'package:organization/common/widgets/appbar.dart';
import 'package:organization/features/weekly_council/application/providers/weekly_council_provider.dart';
import 'package:organization/features/weekly_council/domain/enums/meeting_status_enum.dart';
import 'package:organization/features/weekly_council/domain/enums/week_filtertype.dart';
import 'package:organization/features/weekly_council/domain/model/filtering_week_model.dart';
import 'package:organization/features/weekly_council/presentation/pages/weekly_council.groupbarsheet.dart';
import 'package:organization/features/weekly_council/presentation/pages/weekly_council_barchart.dart';
import 'package:organization/features/weekly_council/presentation/pages/weekly_council_flchart.dart';
import 'package:organization/features/weekly_council/presentation/widgets/weekly_datatable.dart';
import 'package:organization/features/weekly_council/presentation/widgets/weekly_form_widget.dart';
import 'package:organization/features/weekly_council/presentation/widgets/weekly_council_custom_alertbox.dart';

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

  Map<String, Map<String, int>> _groupStatusCountsByWeek(List data) {
    final Map<String, Map<String, int>> result = {};

    for (var item in data) {
      String monthName;
      if (item.month is String) {
        monthName = (item.month as String).substring(0, 3);
      } else {
        monthName = item.month.value.substring(0, 3);
      }

      final weekLabel = "$monthName ${item.week}";

      if (!result.containsKey(weekLabel)) {
        result[weekLabel] = {"done": 0, "notDone": 0, "noResponse": 0};
      }

      switch (item.status) {
        case MeetingStatus.done:
          result[weekLabel]!["done"] = result[weekLabel]!["done"]! + 1;
          break;
        case MeetingStatus.notDone:
          result[weekLabel]!["notDone"] = result[weekLabel]!["notDone"]! + 1;
          break;
        case MeetingStatus.noRsponse:
          result[weekLabel]!["noResponse"] =
              result[weekLabel]!["noResponse"]! + 1;
          break;
        default:
          break;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final weeklyCouncilResult = ref.watch(weeklyCouncilResultProvider);

    return Scaffold(
      backgroundColor: AppColors.blueGray,
      appBar: NavBar,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showWeeklyBottomSheet(context),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.pureWhite,
        elevation: 4,
        child: const Icon(Icons.add),
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

          final groupedData = _groupStatusCountsByWeek(data);

          final weekLabels = groupedData.keys.toList();
          final doneCounts = weekLabels
              .map((w) => groupedData[w]!["done"]!)
              .toList();
          final notDoneCounts = weekLabels
              .map((w) => groupedData[w]!["notDone"]!)
              .toList();
          final noResponseCounts = weekLabels
              .map((w) => groupedData[w]!["noResponse"]!)
              .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.pureWhite,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryBlue.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        color: AppColors.primaryBlue,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Weekly Council',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.blackText,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.pureWhite,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryBlue.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [_buildWeekToggleButtons()],
                  ),
                ),

                const SizedBox(height: 30),

                Column(
                  children: [
                    GroupedWeeklyBarChart(
                      weekLabels: weekLabels,
                      doneCounts: doneCounts,
                      notDoneCounts: notDoneCounts,
                      noResponseCounts: noResponseCounts,
                    ),

                    const SizedBox(height: 30),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildCard(
                            child: buildDataTable(filteredData, selectedWeek),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 2,
                          child: _buildCard(
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
              ],
            ),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
          ),
        ),
        error: (e, _) => Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.pureWhite,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              "Error: $e",
              style: TextStyle(color: Colors.red[600], fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: child,
    );
  }

  Widget _buildWeekToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildToggleButton(
          'This Week',
          WeekFilterType.thisWeek,
          () => setState(() {
            selectedFilter = WeekFilterType.thisWeek;
            selectedWeek = DateTime.now().getThisWeek();
          }),
        ),
        const SizedBox(width: 12),
        _buildToggleButton(
          'Last Week',
          WeekFilterType.lastWeek,
          () => setState(() {
            selectedFilter = WeekFilterType.lastWeek;
            selectedWeek = DateTime.now().getLastWeek();
          }),
        ),
        const SizedBox(width: 12),
        _buildToggleButton('Custom', WeekFilterType.custom, () async {
          _showCustomWeekDialog();
        }),
      ],
    );
  }

  void _showCustomWeekDialog() async {
    final result = await showDialog<FilteringWeekModel>(
      context: context,
      builder: (context) =>
          CustomWeekSelectionDialog(initialWeek: selectedWeek),
    );

    if (result != null) {
      setState(() {
        selectedWeek = result;
        selectedFilter = WeekFilterType.custom;
      });
    }
  }

  Widget _buildToggleButton(
    String text,
    WeekFilterType filterType,
    VoidCallback onPressed,
  ) {
    final isSelected = selectedFilter == filterType;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? AppColors.primaryBlue
            : AppColors.pureWhite,
        foregroundColor: isSelected ? AppColors.pureWhite : AppColors.blackText,
        elevation: isSelected ? 3 : 1,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? AppColors.primaryBlue : AppColors.veryLightBlue,
            width: 1.5,
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }

  void _showWeeklyBottomSheet(BuildContext context) async {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: WeeklyFormWidget(
          initialYear: selectedWeek.year,
          initialMonth: selectedWeek.month,
          initialWeek: selectedWeek.week,
        ),
      ),
    );
  }
}
