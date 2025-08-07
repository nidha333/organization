enum MonthlyWeeks {
  week1('Week 1'),
  week2('Week 2'),
  week3('Week 3'),
  week4('Week 4'),
  week5('Week 5');

  const MonthlyWeeks(this.value);
  final String value;
  @override
  String toString() {
    return value;
  }

  String toMap() {
    return value;
  }

  static MonthlyWeeks fromMap(String str) {
    return MonthlyWeeks.values.firstWhere(
      (week) => week.value.toLowerCase() == str.toLowerCase(),
      orElse: () => MonthlyWeeks.week1,
    );
  }
}
