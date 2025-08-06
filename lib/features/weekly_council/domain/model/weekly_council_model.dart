class WeeklyData {
  final String area;
  final String status;
  final int percentage;
  final String month;
  final int week;
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
      'status': status,
      'percentage': percentage,
      'month': month,
      'week': week,
      'year': year,
    };
  }
}
