enum MonthsEnum {
  january('Jan'),
  february('Feb'),
  march('Mar'),
  april('Apr'),
  may('May'),
  june('Jun'),
  july('Jul'),
  august('Aug'),
  september('Sep'),
  october('Oct'),
  november('Nov'),
  december('Dec');

  const MonthsEnum(this.value);
  final String value;

  @override
  String toString() {
    return value;
  }

  String toMap() {
    return value;
  }

  static MonthsEnum fromMap(String str) {
    return MonthsEnum.values.firstWhere(
      (month) => month.value.toLowerCase() == str.toLowerCase(),
      orElse: () => MonthsEnum.january,
    );
  }

  static MonthsEnum getMonthFromInt(int num) {
    return MonthsEnum.values[num - 1];
  }
}
