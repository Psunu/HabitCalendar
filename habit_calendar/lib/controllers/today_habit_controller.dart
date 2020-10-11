import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/enums/completion.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/services/database/db_service.dart';
import 'package:habit_calendar/utils/utils.dart';

import '../enums/day_of_the_week.dart';

class TodayHabitController extends GetxController {
  DateTime today = DateTime.now();
  final todayHabits = List<Habit>().obs;
  final todayEvents = List<Event>().obs;

  final DbService _dbService = Get.find<DbService>();

  // animationControllers is map to keep every each HabitTile animation controllers
  // key : habit id, value : animation controller
  Map<int, AnimationController> animationControllers =
      Map<int, AnimationController>();

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
    today = DateTime(today.year, today.month, today.day);

    todayHabits.bindStream(_dbService.database.habitDao
        .watchHabitsByWeek(DayOfTheWeek.values[today.weekday - 1]));
    todayEvents
        .bindStream(_dbService.database.eventDao.watchEventsByDate(today));

    todayHabits.listen((list) {
      _sortTodayHabits(list);
    });

    todayEvents.listen((list) {
      todayHabits.refresh();
    });

    super.onInit();
  }

  @override
  void onClose() {
    animationControllers.forEach((key, value) {
      value.dispose();
    });
    super.onClose();
  }

  // Primary methods
  Future<void> complete(int habitId) async {
    if (todayEvents
        .where(
          (event) => _eventsWhere(event, habitId),
        )
        .isEmpty) {
      _dbService.database.eventDao.insertEvent(
        Event(
          id: null,
          date: today,
          completion: Completion.Ok.index,
          habitId: habitId,
        ),
      );
    }
  }

  Future<void> notComplete(int habitId) async {
    Event event = todayEvents.singleWhere(
      (event) => _eventsWhere(event, habitId),
      orElse: () => null,
    );

    if (event != null) {
      _dbService.database.eventDao.deleteEvent(event);
    }
  }

  // Utility Methods
  String formWhatTime(DateTime when) {
    if (when == null) return '오늘안에';
    if (when.hour - 12 < 1)
      return 'AM ${Utils.twoDigits(when.hour)}:${Utils.twoDigits(when.minute)}';
    else
      return 'PM ${Utils.twoDigits(when.hour - 12)}:${Utils.twoDigits(when.minute)}';
  }

  bool isCompleted(int habitId) {
    return todayEvents
                .singleWhere(
                  (event) => _eventsWhere(event, habitId),
                  orElse: () => null,
                )
                ?.completion ==
            Completion.Ok.index ??
        false;
  }

  bool _eventsWhere(Event event, int habitId) {
    if (event == null) return false;

    return event.date.isAtSameMomentAs(today) && event.habitId == habitId;
  }

  void _sortTodayHabits(List<Habit> list) {
    list.sort((a, b) {
      final aEvent = todayEvents.singleWhere(
          (event) => _eventsWhere(event, a.id),
          orElse: () => null);
      final bEvent = todayEvents.singleWhere(
          (event) => _eventsWhere(event, b.id),
          orElse: () => null);

      // 1st Sort : Sort by event is completed
      // Move habit that is completed to end of list
      if (aEvent.isNull && !bEvent.isNull)
        return -1;
      else if (bEvent.isNull && !aEvent.isNull)
        return 1;
      // 2nd Sort : Sort by whatTime is not null
      // Move habit has whatTime is null to end of list
      else {
        if (a.whatTime.isNull && !b.whatTime.isNull)
          return 1;
        else if (b.whatTime.isNull && !a.whatTime.isNull)
          return -1;
        // 3rd Sort : Sort by whatTime
        // Move habit has more late whatTime to end of list
        else {
          int value = a.whatTime.compareTo(b.whatTime);
          if (value != 0)
            return value;
          // 4th Sort : Sort by name alphabet
          else
            return a.name.compareTo(b.name);
        }
      }
    });
  }
}
