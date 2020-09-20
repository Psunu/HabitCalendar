import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/services/database/db_service.dart';
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
    print(Habit.fromJson(fakeHabits[0]).toString());
    Get.find<DbService>()
        .database
        .habitDao
        .insertHabit(Habit.fromJson(fakeHabits[1]));
  }
}
