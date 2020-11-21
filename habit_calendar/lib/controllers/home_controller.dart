import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/services/database/db_service.dart';
import 'package:habit_calendar/views/calendar_view.dart';
import 'package:habit_calendar/views/manage_habit_view.dart';
import 'package:habit_calendar/views/today_habit_view.dart';

import '../services/database/db_service.dart';

class HomeController extends GetxController {
  final dbService = Get.find<DbService>();

  int currentIndex = 0;

  final List<Widget> pages = <Widget>[
    TodayHabitView(),
    CalendarView(),
  ];

  // Primary methods
  void navigateToManage() {
    final route = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          ManageHabitView(),
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
}
