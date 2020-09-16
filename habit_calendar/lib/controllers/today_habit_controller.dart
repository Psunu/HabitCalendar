import 'package:get/get.dart';
import 'package:habit_calendar/models/event.dart';
import 'package:habit_calendar/models/habit.dart';
import 'package:habit_calendar/test_data.dart';

class TodayHabitController extends GetxController {
  DateTime today = DateTime.now();
  List<Habit> todayHabits = List<Habit>();
  List<Event> todayEvents = List<Event>();

  TodayHabitController() {
    for (int i = 0; i < 2; i++) {
      todayHabits.add(Habit.fromJson(fakeHabits[i]));
    }
  }
  String get formedToday => '${today.month}월 ${today.day}일 ($weekdayString)';
  String get weekdayString {
    switch (today.weekday) {
      case 1:
        return '월';
      case 2:
        return '화';
      case 3:
        return '수';
      case 4:
        return '목';
      case 5:
        return '금';
      case 6:
        return '토';
      case 7:
        return '일';
      default:
        return null;
    }
  }

  double get todayPercentage {
    if (todayEvents.length == 0 || todayHabits.length == 0) return 0;
    return todayEvents.length / todayHabits.length;
  }

  String formWhen(DateTime when) {
    if (when == null) return '오늘안에';
    if (when.hour - 12 < 1)
      return 'AM ${when.hour}:${when.minute}';
    else
      return 'PM ${when.hour - 12}:${when.minute}';
  }
}
