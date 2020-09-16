import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
}
