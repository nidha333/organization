import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organization/common/constants/app_colors.dart';
import 'package:organization/common/widgets/appbar.dart';
import 'package:organization/features/monthly_council/application/providers/monthly_council_providers.dart';
import 'package:organization/features/monthly_council/presentation/pages/monthly_barchart.dart'; // Your grouped bar chart widget
import 'package:organization/features/monthly_council/presentation/pages/monthly_council_groupbarchart.dart';
import 'package:organization/features/monthly_council/presentation/pages/monthly_council_piechart.dart';
import 'package:organization/features/monthly_council/presentation/pages/monthly_councile_form_dialog.dart';
import 'package:organization/features/monthly_council/presentation/widgets/monthly_council_custombox.dart';
import 'package:organization/features/monthly_council/presentation/widgets/monthly_database.dart';
import 'package:organization/features/weekly_council/domain/enums/meeting_status_enum.dart';
import 'package:organization/features/weekly_council/domain/enums/months_enum.dart';

class MonthlyCouncilPage extends ConsumerStatefulWidget {
  const MonthlyCouncilPage({super.key});

  @override
  ConsumerState<MonthlyCouncilPage> createState() => _MonthlyCouncilPageState();
}

class _MonthlyCouncilPageState extends ConsumerState<MonthlyCouncilPage> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  bool isCustomFilter = false;
  DateTime? selectedDate;

  Map<MonthsEnum, Map<String, int>> _aggregateMonthlyStatusCounts(List data) {
    final Map<MonthsEnum, Map<String, int>> result = {};

    for (var item in data) {
      MonthsEnum monthEnum;

      if (item.month is String) {
        monthEnum = MonthsEnum.fromMap(item.month as String);
      } else if (item.month is MonthsEnum) {
        monthEnum = item.month as MonthsEnum;
      } else {
        monthEnum = MonthsEnum.january;
      }

      if (!result.containsKey(monthEnum)) {
        result[monthEnum] = {'done': 0, 'notDone': 0, 'noResponse': 0};
      }

      switch (item.status) {
        case MeetingStatus.done:
          result[monthEnum]!['done'] = result[monthEnum]!['done']! + 1;
          break;
        case MeetingStatus.notDone:
          result[monthEnum]!['notDone'] = result[monthEnum]!['notDone']! + 1;
          break;
        case MeetingStatus.noRsponse:
          result[monthEnum]!['noResponse'] =
              result[monthEnum]!['noResponse']! + 1;
          break;
        default:
          break;
      }
    }

    return result;
  }

  String get _selectedFilterType {
    final now = DateTime.now();
    if (selectedMonth == now.month && selectedYear == now.year) {
      return 'thisMonth';
    } else if (selectedMonth == now.month - 1 ||
        (selectedMonth == 12 &&
            now.month == 1 &&
            selectedYear == now.year - 1)) {
      return 'lastMonth';
    }
    return 'custom';
  }

  @override
  Widget build(BuildContext context) {
    final storedDataAsync = ref.watch(getMonthlyCouncilProvider);

    return Scaffold(
      backgroundColor: AppColors.blueGray,
      appBar: NavBar,
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddMonthlyCouncilDialog(context),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.pureWhite,
        elevation: 4,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header
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
                    Icons.calendar_view_month_rounded,
                    color: AppColors.primaryBlue,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Monthly Council',
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

            // Filter Buttons
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
                children: [
                  _buildToggleButton(
                    'This Month',
                    'thisMonth',
                    () => setState(() {
                      selectedMonth = DateTime.now().month;
                      selectedYear = DateTime.now().year;
                      isCustomFilter = false;
                    }),
                  ),
                  const SizedBox(width: 12),
                  _buildToggleButton('Last Month', 'lastMonth', () {
                    final now = DateTime.now();
                    final lastMonth = DateTime(now.year, now.month - 1, 1);
                    setState(() {
                      selectedMonth = lastMonth.month;
                      selectedYear = lastMonth.year;
                      isCustomFilter = false;
                    });
                  }),
                  const SizedBox(width: 12),
                  _buildToggleButton(
                    'Custom',
                    'custom',
                    _showCustomMonthDialog,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Content
            SizedBox(
              height: 500,
              child: storedDataAsync.when(
                data: (data) {
                  if (data.isEmpty) {
                    return Center(
                      child: _buildEmptyStateCard(
                        // ignore: unnecessary_null_comparison
                        data == null
                            ? "No data available"
                            : "No monthly records found",
                        // ignore: unnecessary_null_comparison
                        data == null ? Icons.info_outline : Icons.folder_open,
                        // ignore: unnecessary_null_comparison
                        data == null ? Colors.orange : Colors.grey,
                      ),
                    );
                  }

                  final filteredData = data.where((e) {
                    final date = e.day;
                    if (isCustomFilter && selectedDate != null) {
                      return date.year == selectedDate!.year &&
                          date.month == selectedDate!.month &&
                          date.day == selectedDate!.day;
                    } else {
                      return date.month == selectedMonth &&
                          date.year == selectedYear;
                    }
                  }).toList();

                  final monthlyStatusMap = _aggregateMonthlyStatusCounts(data);

                  final monthsWithData = monthlyStatusMap.keys.toList()
                    ..sort((a, b) => a.index.compareTo(b.index));

                  final monthLabels = monthsWithData;

                  final doneCounts = monthLabels
                      .map((m) => monthlyStatusMap[m]!['done'] ?? 0)
                      .toList();
                  final notDoneCounts = monthLabels
                      .map((m) => monthlyStatusMap[m]!['notDone'] ?? 0)
                      .toList();
                  final noResponseCounts = monthLabels
                      .map((m) => monthlyStatusMap[m]!['noResponse'] ?? 0)
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

                  final areas = filteredData.map((e) => e.area).toList();
                  final participation = filteredData.map((e) {
                    final val = e.participation;
                    return val.toDouble();
                  }).toList();

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        GroupedMonthlyBarChart(
                          monthLabels: monthLabels,
                          doneCounts: doneCounts,
                          notDoneCounts: notDoneCounts,
                          noResponseCounts: noResponseCounts,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: _buildCard(
                                child: buildMonthlyDataTable(
                                  filteredData,
                                  isCustomFilter && selectedDate != null
                                      ? selectedDate!
                                      : DateTime(
                                          selectedYear,
                                          selectedMonth,
                                          1,
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              flex: 2,
                              child: _buildCard(
                                child: MonthlyCouncilPiechart(
                                  doneCount: doneCount,
                                  notDoneCount: notDoneCount,
                                  noResponseCount: noResponseCount,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 3,
                              child: _buildCard(
                                child: MonthlyBarchart(
                                  areas: areas,
                                  participation: participation,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                loading: () => Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryBlue,
                    ),
                  ),
                ),
                error: (err, stack) => Center(
                  child: _buildEmptyStateCard(
                    'Error loading data: $err',
                    Icons.error_outline,
                    Colors.red[600]!,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      height: 400,
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

  void _showCustomMonthDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomMonthPickerDialog(
          initialYear: selectedYear,
          initialMonth: MonthsEnum.values[selectedMonth - 1],
          onApply: (year, month) {
            setState(() {
              selectedYear = year;
              selectedMonth = month.index + 1;
              isCustomFilter = false;
            });
          },
        );
      },
    );
  }

  Widget _buildEmptyStateCard(String message, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(32),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: color),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(
    String text,
    String filterType,
    VoidCallback onPressed,
  ) {
    final isSelected = _selectedFilterType == filterType;

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

  void showAddMonthlyCouncilDialog(BuildContext context) {
    final now = DateTime.now();
    final initialYear = now.year;
    final initialMonth = MonthsEnum.values[now.month - 1];
    final day = now;
    showDialog(
      context: context,
      builder: (_) => MonthlyCouncilFormDialog(
        initialYear: initialYear,
        day: day,
        initialMonth: initialMonth,
      ),
    );
  }
}
