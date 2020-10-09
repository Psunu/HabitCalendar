import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/enums/completion.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/services/database/db_service.dart';
import 'package:habit_calendar/utils/utils.dart';
import 'package:habit_calendar/widgets/habit_tile.dart';

import '../enums/day_of_the_week.dart';

class TodayHabitController extends GetxController {
  DateTime today = DateTime.now();
  final todayHabits = List<Habit>().obs;
  final todayEvents = List<Event>().obs;

  final DbService _dbService = Get.find<DbService>();

  // Get Set
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

  int get completedEvent => todayEvents
      .where((element) => element.completion != Completion.No.index)
      .length;

  double get todayPercentage {
    if (todayEvents.length == 0 || todayHabits.length == 0) return 0;
    return completedEvent / todayHabits.length;
  }

  // Controller life cycle
  @override
  void onInit() async {
    todayHabits.bindStream(_dbService.database.habitDao
        .watchHabitsByWeek(DayOfTheWeek.values[today.weekday - 1]));
    todayEvents.bindStream(_dbService.database.eventDao.watchAllEvents());

    todayHabits.listen((list) {
      list.forEach((element) => print(element.toString()));
    });
    super.onInit();
  }

  // Utility Methods
  List<Widget> buildHabits() {
    List<Widget> result = List<Widget>();
    todayHabits.forEach((element) {
      result.add(HabitTile(
        key: ValueKey(element.id),
        date: Text(formWhatTime(element.whatTime)),
        name: Text(element.name),
        background: Container(
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: Get.theme.accentColor,
            borderRadius: BorderRadius.circular(
              Constants.mediumBorderRadius,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Icon(
              Icons.check_circle_outline,
              color: Get.theme.scaffoldBackgroundColor,
              size: 30.0,
            ),
          ),
        ),
        secondaryBackground: Container(
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(
              Constants.mediumBorderRadius,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Icon(
              Icons.replay,
              color: Get.theme.scaffoldBackgroundColor,
              size: 30.0,
            ),
          ),
        ),
      ));
    });

    return result;
  }

  String formWhatTime(DateTime when) {
    if (when == null) return '오늘안에';
    if (when.hour - 12 < 1)
      return 'AM ${Utils.twoDigits(when.hour)}:${Utils.twoDigits(when.minute)}';
    else
      return 'PM ${Utils.twoDigits(when.hour - 12)}:${Utils.twoDigits(when.minute)}';
  }
}
