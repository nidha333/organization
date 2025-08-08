// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:organization/features/weekly_council/domain/enums/meeting_status_enum.dart';
import 'package:organization/features/weekly_council/domain/enums/months_enum.dart';

class MonthlyCouncil {
  final String area;
  final int year;
  final MonthsEnum month;
  final int participation;
  final MeetingStatus status;
  final DateTime day;
  MonthlyCouncil({required this.area, required this.year, required this.month, required this.participation, required this.status, required this.day});

  MonthlyCouncil copyWith({String? area, int? year, MonthsEnum? month, int? participation, MeetingStatus? status, DateTime? day}) {
    return MonthlyCouncil(
      area: area ?? this.area,
      year: year ?? this.year,
      month: month ?? this.month,
      participation: participation ?? this.participation,
      status: status ?? this.status,
      day: day ?? this.day,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'area': area,
      'year': year,
      'month': month.toMap(),
      'participation': participation,
      'status': status.toMap(),
      'day': day.millisecondsSinceEpoch,
    };
  }

  factory MonthlyCouncil.fromMap(Map<String, dynamic> map) {
    return MonthlyCouncil(
      area: map['area'] as String,
      year: map['year'] as int,
      month: MonthsEnum.fromMap(map['month']),
      participation: map['participation'] as int,
      status: MeetingStatus.fromMap(map['status']),
      day: DateTime.fromMillisecondsSinceEpoch(map['day'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory MonthlyCouncil.fromJson(String source) => MonthlyCouncil.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MonthlyCouncil(area: $area, year: $year, month: $month, participation: $participation, status: $status, day: $day)';
  }

  @override
  bool operator ==(covariant MonthlyCouncil other) {
    if (identical(this, other)) return true;

    return other.area == area &&
        other.year == year &&
        other.month == month &&
        other.participation == participation &&
        other.status == status &&
        other.day == day;
  }

  @override
  int get hashCode {
    return area.hashCode ^ year.hashCode ^ month.hashCode ^ participation.hashCode ^ status.hashCode ^ day.hashCode;
  }
}
