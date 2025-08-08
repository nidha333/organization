import 'dart:developer';

import 'package:organization/features/weekly_council/domain/enums/months_enum.dart';
import 'package:organization/features/weekly_council/domain/enums/weeks_enum.dart';
import 'package:organization/features/weekly_council/domain/model/filtering_week_model.dart';

extension GetThisWeek on DateTime {
  FilteringWeekModel getThisWeek() {
    final year = this.year;
    final month = MonthsEnum.getMonthFromInt(this.month);
    final week = _calculateWeek(this.day);
    return FilteringWeekModel(year: year, month: month, week: week);
  }

  FilteringWeekModel getLastWeek() {
    final lastWeekDate = subtract(const Duration(days: 7));
    final year = lastWeekDate.year;
    final month = MonthsEnum.getMonthFromInt(lastWeekDate.month);
    final week = _calculateWeek(lastWeekDate.day);
    return FilteringWeekModel(year: year, month: month, week: week);
  }

  static MonthlyWeeks _calculateWeek(int day) {
    if (day <= 7) return MonthlyWeeks.week1;
    if (day <= 14) return MonthlyWeeks.week2;
    if (day <= 21) return MonthlyWeeks.week3;
    if (day <= 28) return MonthlyWeeks.week4;
    return MonthlyWeeks.week5;
  }
}
