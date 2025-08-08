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
}
