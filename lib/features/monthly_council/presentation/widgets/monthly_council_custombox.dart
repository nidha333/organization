import 'package:flutter/material.dart';
import 'package:organization/common/constants/app_colors.dart';
import 'package:organization/features/weekly_council/domain/enums/months_enum.dart';

class CustomMonthPickerDialog extends StatefulWidget {
  final int initialYear;
  final MonthsEnum initialMonth;
  final Function(int year, MonthsEnum month) onApply;

  const CustomMonthPickerDialog({
    super.key,
    required this.initialYear,
    required this.initialMonth,
    required this.onApply,
  });

  @override
  State<CustomMonthPickerDialog> createState() =>
      _CustomMonthPickerDialogState();
}

class _CustomMonthPickerDialogState extends State<CustomMonthPickerDialog> {
  late int tempSelectedYear;
  late MonthsEnum tempSelectedMonth;

  @override
  void initState() {
    super.initState();
    tempSelectedYear = widget.initialYear;
    tempSelectedMonth = widget.initialMonth;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.pureWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Container(
        padding: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.veryLightBlue, width: 1),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.date_range, color: AppColors.primaryBlue, size: 24),
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
                        setState(() {
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
                        child: Text(month.value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onApply(tempSelectedYear, tempSelectedMonth);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: AppColors.pureWhite,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
  }
}
