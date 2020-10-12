class Utils {
  static String getFormedDate(DateTime date) =>
      '${date.month}월 ${date.day}일 (${Utils.getWeekString(date.weekday - 1)})';
  static String getWeekString(int week) {
    switch (week) {
      case 0:
        return '월';
      case 1:
        return '화';
      case 2:
        return '수';
      case 3:
        return '목';
      case 4:
        return '금';
      case 5:
        return '토';
      case 6:
        return '일';
    }
    return '월';
  }

  static String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
}
