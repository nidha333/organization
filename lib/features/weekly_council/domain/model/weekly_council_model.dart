import 'package:organization/features/weekly_council/domain/enums/months.dart';
import 'package:organization/features/weekly_council/domain/enums/week.dart';

class WeeklyData {
  final String area;
  final String status;
  final int percentage;
  final Months month;
  final MonthlyWeeks week;
  final int year;

  WeeklyData({
    required this.area,
    required this.status,
    required this.percentage,
    required this.month,
    required this.week,
    required this.year,
    d,
  });

  Map<String, dynamic> toMap() {
    return {
      'area': area,
      'status': status,
      'percentage': percentage,
      'month': month,
      'week': week,
      'year': year,
    };
  }
}
