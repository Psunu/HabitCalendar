import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
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

    todayEvents.listen((list) {
      list.forEach((element) {
        print(element);
      });
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
          (event) =>
              event.date.isAtSameMomentAs(today) && event.habitId == habitId,
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
      (event) => event.date.isAtSameMomentAs(today) && event.habitId == habitId,
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
                  (event) =>
                      event.date.isAtSameMomentAs(today) &&
                      event.habitId == habitId,
                  orElse: () => null,
                )
                ?.completion ==
            Completion.Ok.index ??
        false;
  }
}

class HabitTileBackground extends StatefulWidget {
  HabitTileBackground({
    @required this.color,
    @required this.child,
  });

  final Color color;
  final Widget child;

  @override
  _HabitTileBackgroundState createState() => _HabitTileBackgroundState();
}

class _HabitTileBackgroundState extends State<HabitTileBackground> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(
          Constants.mediumBorderRadius,
        ),
      ),
      child: widget.child,
    );
  }
}
