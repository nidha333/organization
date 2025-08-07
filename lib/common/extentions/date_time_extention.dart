import 'package:organization/features/weekly_council/domain/enums/months_enum.dart';
import 'package:organization/features/weekly_council/domain/enums/weeks_enum.dart';
import 'package:organization/features/weekly_council/domain/model/filtering_week_model.dart';

extension GetThisWeek on DateTime {
  FilteringWeekModel getThisWeek() {
    final year = this.year;
    final m = this.month;
    final month = MonthsEnum.getMonthFromInt(m);
    MonthlyWeeks week = MonthlyWeeks.week1;
    final day = this.day;

    if (day <= 7) {
      week = MonthlyWeeks.week1;
    } else if (day <= 14) {
      week = MonthlyWeeks.week2;
    } else if (day <= 21) {
      week = MonthlyWeeks.week3;
    } else if (day <= 28) {
      week = MonthlyWeeks.week4;
    } else {
      week = MonthlyWeeks.week5;
    }
    final w = FilteringWeekModel(year: year, month: month, week: week);
    return w;
  }

  FilteringWeekModel getLastWeek() {
    DateTime lastWeekDate = this.subtract(Duration(days: 7));
    final year = lastWeekDate.year;
    final m = lastWeekDate.month;
    final month = MonthsEnum.getMonthFromInt(m);
    MonthlyWeeks week = _calculateWeek(lastWeekDate.day);

    return FilteringWeekModel(year: year, month: month, week: week);
  }

  static MonthlyWeeks _calculateWeek(int day) {
    if (day <= 7) {
      return MonthlyWeeks.week1;
    } else if (day <= 14) {
      return MonthlyWeeks.week2;
    } else if (day <= 21) {
      return MonthlyWeeks.week3;
    } else if (day <= 28) {
      return MonthlyWeeks.week4;
    } else {
      return MonthlyWeeks.week5;
    }
  }
}
