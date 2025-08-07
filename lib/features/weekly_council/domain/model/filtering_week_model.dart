import 'package:organization/features/weekly_council/domain/enums/months_enum.dart';
import 'package:organization/features/weekly_council/domain/enums/weeks_enum.dart';

class FilteringWeekModel {
  final int year;
  final MonthsEnum month;
  final MonthlyWeeks week;

  FilteringWeekModel({
    required this.year,
    required this.month,
    required this.week,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FilteringWeekModel &&
        other.year == year &&
        other.month == month &&
        other.week == week;
  }

  @override
  int get hashCode => year.hashCode ^ month.hashCode ^ week.hashCode;

  @override
  String toString() =>
      'FilteringWeekModel(year: $year, month: $month, week: $week)';
}
