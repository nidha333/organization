import 'package:organization/features/weekly_council/domain/enums/months_enum.dart';
import 'package:organization/features/weekly_council/domain/enums/status_enum.dart';
import 'package:organization/features/weekly_council/domain/enums/week_enum.dart';

class WeeklyData {
  final String area;
  final MeetingStatus status;
  final int percentage;
  final MonthsEnum month;
  final MonthlyWeeks week;
  final int year;

  WeeklyData({
    required this.area,
    required this.status,
    required this.percentage,
    required this.month,
    required this.week,
    required this.year,
  });

  Map<String, dynamic> toMap() {
    return {
      'area': area,
      'status': status.toMap(),
      'percentage': percentage,
      'month': month.toMap(),
      'week': week.toMap(),
      'year': year,
    };
  }

  factory WeeklyData.fromMap(Map<String, dynamic> map) {
    return WeeklyData(
      area: map['area'] ?? '',
      status: MeetingStatus.fromMap(map['status']),
      percentage: map['percentage'] ?? 0,
      month: MonthsEnum.fromMap(map['month']),
      week: MonthlyWeeks.fromMap(map['week']),
      year: map['year'] ?? 0,
    );
  }
}
