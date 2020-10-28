import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/services/database/db_service.dart';
import 'package:habit_calendar/views/manage_habit_edit.dart';
import 'package:habit_calendar/views/today_habit.dart';

import '../enums/day_of_the_week.dart';
import '../services/database/app_database.dart';
import '../services/database/db_service.dart';

class HomeController extends GetxController {
  final dbService = Get.find<DbService>();

  int currentIndex = 0;

  final List<Widget> pages = <Widget>[
    TodayHabit(),
    Container(
      child: Text('Page2'),
    ),
  ];

  // Primary methods
  void navigateToManage() {
    final route = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ManageHabit(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin = Offset(-1.0, 0.0);
        final end = Offset.zero;
        final curve = Curves.ease;

        final tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
    Navigator.of(Get.context).push(route);
  }

  void onBottomNavTapped(int index) {
    currentIndex = index;
    update();
  }

  Future<void> addHabit() async {
    await dbService.database.habitDao.insertHabit(Habit(
        id: 2,
        name: 'habit2',
        statusBarFix: false,
        groupId: 0,
        notificationTypeId: 0));

    await dbService.database.habitWeekDao
        .insertHabitWeek(HabitWeek(habitId: 2, week: DayOfTheWeek.Tue.index));

    print('habits');
    (await dbService.database.habitDao.getAllHabits())
        .forEach((element) => print(element.toString()));
  }
}
