import 'package:get/get.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/services/database/db_service.dart';

class MakeHabitController extends GetxController {
  // Database controller
  final dbService = Get.find<DbService>();

  // Database data
  final habits = List<Habit>().obs;
  final groups = List<Group>().obs;

  @override
  void onInit() {
    habits.bindStream(dbService.database.habitDao.watchAllHabits());
    groups.bindStream(dbService.database.groupDao.watchAllGroups());

    super.onInit();
  }

  void onSave(
    Habit habit,
    List<int> selectedWeeks,
    List<Duration> noticeTimes,
  ) async {
    print('[MakeHabit] Habit: ' + habit.toString());
    print('[MakeHabit] Weeks: ' + selectedWeeks.toString());
    print('[MakeHabit] notificationTimes ' + noticeTimes.toString());

    int id = await dbService.database.habitDao.insertHabit(habit);

    final weeks = List<HabitWeek>();
    final times = List<HabitNoticeTime>();

    selectedWeeks.forEach((weekId) {
      weeks.add(HabitWeek(habitId: id, week: weekId));
    });

    noticeTimes.forEach((duration) {
      times.add(HabitNoticeTime(
          id: null, noticeTime: duration.inMinutes, habitId: id));
    });

    final weeksResult =
        await dbService.database.habitWeekDao.insertAllHabitWeeks(weeks);
    final timesResult = await dbService.database.habitNoticeTimeDao
        .insertAllHabitNoticeTimes(times);

    print('[MakeHabit] habit id : $id');
    print('[MakeHabit] weeks ids : ${weeksResult.toString()}');
    print('[MakeHabit] noticeTimes ids : ${timesResult.toString()}');

    Get.back();
  }
}
