import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/services/database/db_service.dart';
import 'package:habit_calendar/widgets/group_maker.dart';
import 'package:habit_calendar/widgets/habit_info_widget.dart';

const _kIconSize = 22.0;

enum _PopupItemType {
  delete,
}

class ManageHabitController extends GetxController {
  final groups = List<Group>().obs;
  final habits = List<Habit>().obs;
  final weeks = List<HabitWeek>().obs;

  final DbService _dbService = Get.find<DbService>();

  // Controller life cycle
  @override
  void onInit() {
    groups.bindStream(_dbService.database.groupDao.watchAllGroups());
    habits.bindStream(_dbService.database.habitDao.watchAllHabits());
    weeks.bindStream(_dbService.database.habitWeekDao.watchAllHabitWeeks());

    super.onInit();
  }

  // Primary methods
  Future<void> saveHabit(Habit habit, List<HabitWeek> changedWeeks) async {
    print(await _dbService.database.habitDao.updateHabit(
      Habit(
        id: habit.id,
        name: habit.name,
        statusBarFix: habit.statusBarFix,
        groupId: habit.groupId,
        notificationTypeId: habit.notificationTypeId,
        notificationTime: habit.notificationTime,
        whatTime: habit.whatTime,
        description: habit.description,
      ),
    ));

    weeks
        .where((element) => element.habitId == habit.id)
        .forEach((element) async {
      await _dbService.database.habitWeekDao.deleteHabitWeek(element);
    });
    changedWeeks.forEach((element) async {
      await _dbService.database.habitWeekDao.insertHabitWeek(element);
    });

    Get.back();
  }

  void onAddGroupTapped() {
    customShowModal(builder: (context) => GroupMaker());
  }

  void onHabitTapped(int habitId) {
    customShowModal(
      builder: (context) => HabitInfoWidget(
        habit: habits.singleWhere((habit) => habit.id == habitId),
        habits: habits,
        groups: groups,
        weeks: weeks,
        onSave: saveHabit,
        actions: [
          Material(
            type: MaterialType.transparency,
            child: PopupMenuButton<_PopupItemType>(
              itemBuilder: (context) => <PopupMenuEntry<_PopupItemType>>[
                PopupMenuItem<_PopupItemType>(
                  value: _PopupItemType.delete,
                  child: Text(
                    '삭제'.tr.capitalizeFirst,
                    style: Get.textTheme.bodyText2,
                  ),
                )
              ],
              onSelected: (type) {
                switch (type) {
                  case _PopupItemType.delete:
                    // TODO add snackbar
                    delete(habitId);
                    Navigator.pop(context);
                    break;
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  Constants.smallBorderRadius,
                ),
              ),
              child: Icon(
                Icons.more_vert,
                size: _kIconSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void delete(int habitId) {
    _dbService.database.habitDao.deleteHabitById(habitId);
  }

  // Utility methods
  int numGroupMembers(int groupId) =>
      habits.where((habit) => habit.groupId == groupId).length;
  List<Habit> groupMembers(int groupId) =>
      habits.where((habit) => habit.groupId == groupId).toList();

  Future<T> customShowModal<T>(
      {Widget Function(BuildContext context) builder}) {
    return showModal<T>(
      context: Get.context,
      configuration: FadeScaleTransitionConfiguration(),
      builder: (context) => Center(
        child: SingleChildScrollView(
          // This padding works like resizeToAvoidBottomInset
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(Constants.padding),
              margin: const EdgeInsets.all(Constants.padding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  Constants.largeBorderRadius,
                ),
              ),
              child: builder(context),
            ),
          ),
        ),
      ),
    );
  }
}
