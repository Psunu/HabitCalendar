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

  static String getWhatTimeString(DateTime whatTime) {
    String result;

    if (whatTime.hour < 12) {
      result = '오전 ';
      result += Utils.twoDigits(whatTime.hour);
    } else {
      result = '오후 ';
      if (whatTime.hour > 12)
        result += Utils.twoDigits(whatTime.hour - 12).toString();
      else
        result += Utils.twoDigits(whatTime.hour);
    }

    result += ' : ${Utils.twoDigits(whatTime.minute)}';

    return result;
  }

  static String getNotificationTimeString(Duration notificationTime) {
    int hours = notificationTime.inHours;
    int minutes = (notificationTime - Duration(hours: hours)).inMinutes;

    String result = '';

    if (hours > 0) {
      result += '$hours 시간 ';
    } else if (minutes < 1) {
      return '즉시 알림';
    }
    result += '$minutes 분 전에 알림';

    return result;
  }

  static String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
}
