import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/models/habit.dart';
import 'package:habit_calendar/services/database/database.dart';
import 'package:habit_calendar/services/database/habit_dao.dart';
import 'package:habit_calendar/test_data.dart';
import 'package:habit_calendar/views/today_habit.dart';

class HomeController extends GetxController {
  int currentIndex = 0;
  final List<Widget> pages = <Widget>[
    TodayHabit(),
    Container(
      child: Text('Page2'),
    ),
  ];

  void onBottomNavTapped(int index) {
    currentIndex = index;
    update();
  }

  Future<void> addHabit() async {
    Get.find<DbService>()
        .getDao<HabitDao>()
        .insert(Habit.fromJson(fakeHabits[0]));
  }
}
