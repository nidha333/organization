import 'package:organization/features/weekly_council/domain/enums/meeting_status_enum.dart';
import 'package:organization/features/weekly_council/domain/enums/months_enum.dart';

class YouthCouncil {
  final String area;
  final MeetingStatus status;
  final int participation;
  final MonthsEnum month;
  final int year;
  final DateTime day;

  YouthCouncil({
    required this.area,
    required this.status,
    required this.participation,
    required this.month,
    required this.year,
    required this.day,
  });

  Map<String, dynamic> toMap() {
    return {
      'area': area,
      'status': status.value,
      'participation': participation,
      'month': month.value,
      'year': year,
      'day': day.toIso8601String(),
    };
  }

  factory YouthCouncil.fromMap(Map<String, dynamic> map) {
    return YouthCouncil(
      area: map['area'] as String,
      status: MeetingStatus.fromMap(map['status']),
      participation: map['participation'] as int,
      month: MonthsEnum.fromMap(map['month']),
      year: map['year'] as int,
      day: DateTime.parse(map['day'] as String),
    );
  }
}
