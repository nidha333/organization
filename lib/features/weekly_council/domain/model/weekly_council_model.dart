import 'package:organization/features/weekly_council/domain/enums/months_enum.dart';
import 'package:organization/features/weekly_council/domain/enums/meeting_status_enum.dart';
import 'package:organization/features/weekly_council/domain/enums/weeks_enum.dart';

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

  /// Convert to map for Supabase
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

  /// Create from Supabase record
  factory WeeklyData.fromMap(Map<String, dynamic> map) {
    return WeeklyData(
      area: map['area'] ?? '',
      status: MeetingStatus.fromMap(map['status']),
      percentage: map['percentage'] ?? 0,
      month: MonthsEnum.fromMap(map['month']?.toString() ?? ''),
      week: MonthlyWeeks.fromMap(map['week']?.toString() ?? ''),
      year: map['year'] ?? 0,
    );
  }
}
