import 'package:flutter/material.dart';
import 'package:organization/common/constants/app_colors.dart';
import 'package:organization/features/weekly_council/domain/enums/months_enum.dart';
import 'package:organization/features/weekly_council/domain/enums/weeks_enum.dart';
import 'package:organization/features/weekly_council/domain/model/filtering_week_model.dart';

class CustomWeekSelectionDialog extends StatefulWidget {
  final FilteringWeekModel initialWeek;

  const CustomWeekSelectionDialog({Key? key, required this.initialWeek})
    : super(key: key);

  @override
  State<CustomWeekSelectionDialog> createState() =>
      _CustomWeekSelectionDialogState();
}

class _CustomWeekSelectionDialogState extends State<CustomWeekSelectionDialog> {
  late int selectedYear;
  late MonthsEnum selectedMonth;
  late MonthlyWeeks selectedWeek;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialWeek.year;
    selectedMonth = widget.initialWeek.month;
    selectedWeek = widget.initialWeek.week;
  }

  @override
  Widget build(BuildContext context) {
    final weeks = MonthlyWeeks.values;

    return AlertDialog(
      title: const Text('Select Custom Week'),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      value: selectedYear,
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
                          setState(() {
                            selectedYear = year;
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
                      value: selectedMonth,
                      isExpanded: true,
                      underline: const SizedBox(),
                      style: TextStyle(color: AppColors.blackText),
                      items: MonthsEnum.values.map((month) {
                        return DropdownMenuItem(
                          value: month,
                          child: Text(month.value),
                        );
                      }).toList(),
                      onChanged: (month) {
                        if (month != null) {
                          setState(() {
                            selectedMonth = month;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Week',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(weeks.length, (index) {
                MonthlyWeeks weekValue = weeks[index];
                int displayNumber = index + 1;
                final isSelected = selectedWeek == weekValue;

                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedWeek = weekValue;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected
                        ? AppColors.primaryBlue
                        : AppColors.pureWhite,
                    foregroundColor: isSelected
                        ? AppColors.pureWhite
                        : AppColors.blackText,
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primaryBlue
                            : AppColors.veryLightBlue,
                        width: 1.5,
                      ),
                    ),
                  ),
                  child: Text(
                    displayNumber.toString(),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryBlue,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(
              context,
              FilteringWeekModel(
                year: selectedYear,
                month: selectedMonth,
                week: selectedWeek,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text(
            'Select',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
