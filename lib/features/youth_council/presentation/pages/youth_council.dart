import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:organization/common/constants/app_colors.dart';
import 'package:organization/common/widgets/appbar.dart';
import 'package:organization/features/monthly_council/presentation/pages/monthly_barchart.dart';
import 'package:organization/features/monthly_council/presentation/pages/monthly_council_piechart.dart';
import 'package:organization/features/monthly_council/presentation/pages/monthly_councile_form_dialog.dart';
import 'package:organization/features/weekly_council/domain/enums/meeting_status_enum.dart';
import 'package:organization/features/weekly_council/domain/enums/months_enum.dart';
import 'package:organization/features/youth_council/application/provider/youth_council_provider.dart';
import 'package:organization/features/youth_council/presentation/widgets/youth_council_datatable.dart';

class YouthCouncil extends ConsumerStatefulWidget {
  const YouthCouncil({super.key});

  @override
  ConsumerState<YouthCouncil> createState() => youthCouncilPageState();
}

// ignore: camel_case_types
class youthCouncilPageState extends ConsumerState<YouthCouncil> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  bool isCustomFilter = false;
  DateTime? selectedDate;

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
    final storedDataAsync = ref.watch(getYouthCouncilProvider);

    return Scaffold(
      backgroundColor: AppColors.blueGray,
      appBar: NavBar,
      floatingActionButton: FloatingActionButton(
        onPressed: () => YouthCouncilFormDialog(context),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: AppColors.pureWhite,
        elevation: 4,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header Section
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
                    'Youth Council',
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

            // Filter Buttons Section
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
                    'This Youth',
                    'thisYouth',
                    () => setState(() {
                      selectedMonth = DateTime.now().month;
                      selectedYear = DateTime.now().year;
                      isCustomFilter = false;
                    }),
                  ),
                  const SizedBox(width: 12),
                  _buildToggleButton('Last Youth', 'lastYouth', () {
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

            // Main Content
            SizedBox(
              height: 500,
              child: storedDataAsync.when(
                data: (data) {
                  if (data == null) {
                    return Center(
                      child: _buildEmptyStateCard(
                        "No data available",
                        Icons.info_outline,
                        Colors.orange,
                      ),
                    );
                  }

                  if (data.isEmpty) {
                    return Center(
                      child: _buildEmptyStateCard(
                        "No youth records found",
                        Icons.folder_open,
                        Colors.grey,
                      ),
                    );
                  }

                  // Filtering logic
                  final monthlyData = data.where((e) {
                    final date = e.day;
                    if (date is! DateTime) return false;

                    if (isCustomFilter && selectedDate != null) {
                      return date.year == selectedDate!.year &&
                          date.month == selectedDate!.month &&
                          date.day == selectedDate!.day;
                    } else {
                      return date.month == selectedMonth &&
                          date.year == selectedYear;
                    }
                  }).toList();

                  final doneCount = monthlyData
                      .where((e) => e.status == MeetingStatus.done)
                      .length;
                  final notDoneCount = monthlyData
                      .where((e) => e.status == MeetingStatus.notDone)
                      .length;
                  final noResponseCount = monthlyData
                      .where((e) => e.status == MeetingStatus.noRsponse)
                      .length;

                  final areas = monthlyData
                      .map((e) => e.area ?? 'Unknown')
                      .toList();
                  final participation = monthlyData.map((e) {
                    final val = e.participation;
                    if (val is num) return val.toDouble();
                    if (val is String) {
                      return double.tryParse(val.toString()) ?? 0.0;
                    }
                    return 0.0;
                  }).toList();

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: _buildCard(
                          child: buildYouthDataTable(
                            monthlyData,

                            isCustomFilter && selectedDate != null
                                ? selectedDate!
                                : DateTime(selectedYear, selectedMonth, 1),
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
                        flex: 2,
                        child: _buildCard(
                          child: MonthlyBarchart(
                            areas: areas,
                            participation: participation,
                          ),
                        ),
                      ),
                    ],
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

  void _showCustomMonthDialog() {
    int tempSelectedYear = selectedYear;
    MonthsEnum tempSelectedMonth = MonthsEnum.values[selectedMonth - 1];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.pureWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Container(
                padding: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.veryLightBlue,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.date_range,
                      color: AppColors.primaryBlue,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Select Month',
                      style: TextStyle(
                        color: AppColors.blackText,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.veryLightBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<int>(
                            value: tempSelectedYear,
                            isExpanded: true,
                            underline: const SizedBox(),
                            style: TextStyle(color: AppColors.blackText),
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
                                  tempSelectedYear = year;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.veryLightBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<MonthsEnum>(
                            value: tempSelectedMonth,
                            isExpanded: true,
                            underline: const SizedBox(),
                            style: TextStyle(color: AppColors.blackText),
                            items: MonthsEnum.values.map((month) {
                              return DropdownMenuItem(
                                value: month,
                                child: Text(month.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setDialogState(() {
                                  tempSelectedMonth = value;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey[600],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedYear = tempSelectedYear;
                      selectedMonth = tempSelectedMonth.index + 1;
                      isCustomFilter = false;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: AppColors.pureWhite,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ignore: non_constant_identifier_names
  void YouthCouncilFormDialog(BuildContext context) {
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
