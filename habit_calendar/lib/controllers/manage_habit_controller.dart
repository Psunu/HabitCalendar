import 'package:get/get.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/services/database/db_service.dart';

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

  // Utility methods
  int numGroupMembers(int groupId) =>
      habits.where((habit) => habit.groupId == groupId).length;
  List<Habit> groupMembers(int groupId) =>
      habits.where((habit) => habit.groupId == groupId).toList();
}
