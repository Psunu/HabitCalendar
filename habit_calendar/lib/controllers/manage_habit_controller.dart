import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/services/database/db_service.dart';
import 'package:habit_calendar/widgets/habit_info_widget.dart';

class ManageHabitController extends GetxController {
  final groups = List<Group>().obs;
  final habits = List<Habit>().obs;

  final DbService _dbService = Get.find<DbService>();

  // Controller life cycle
  @override
  void onInit() {
    groups.bindStream(_dbService.database.groupDao.watchAllGroups());
    habits.bindStream(_dbService.database.habitDao.watchAllHabits());

    super.onInit();
  }

  // Primary methods
  void onHabitTapped(int habitId) {
    // _dbService.database.habitDao.deleteHabitById(habitId);
    showModal(
        context: Get.context,
        configuration: FadeScaleTransitionConfiguration(),
        builder: (context) => Center(
              child: HabitInfoWidget(
                  habit: habits.singleWhere((habit) => habit.id == habitId)),
            ));
  }

  // Utility methods
  int numGroupMembers(int groupId) =>
      habits.where((habit) => habit.groupId == groupId).length;
  List<Habit> groupMembers(int groupId) =>
      habits.where((habit) => habit.groupId == groupId).toList();
}
