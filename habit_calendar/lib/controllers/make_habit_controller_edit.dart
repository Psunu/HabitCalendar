import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/services/database/db_service.dart';

class MakeHabitController extends GetxController {
  MakeHabitController({
    @required this.stepsLength,
  }) : assert(stepsLength != null);

  final int stepsLength;

  // Database controller
  final dbService = Get.find<DbService>();

  // Database data
  final habits = List<Habit>().obs;
  final groups = List<Group>().obs;

  // Steps
  final currentStep = 0.obs;

  final nameTextController = TextEditingController();
  int selectedGroupId = 0;
  Map<int, bool> weeks;
  DateTime whatTime = DateTime(0);
  List<Duration> notificationTimes = List<Duration>();
  final descriptionTextController = TextEditingController();

  @override
  void onInit() {
    habits.bindStream(dbService.database.habitDao.watchAllHabits());
    groups.bindStream(dbService.database.groupDao.watchAllGroups());

    super.onInit();
  }

  @override
  void onClose() {
    nameTextController.dispose();
    descriptionTextController.dispose();

    super.onClose();
  }

  void goNext(int index) {
    if (index + 1 < stepsLength) currentStep.value = index + 1;
  }

  void goPrevious(int index) {
    if (index - 1 > -1) currentStep.value = index - 1;
  }

  void onStep0Save(int groupId) {
    print('[MakeHabit] Name : ${nameTextController.text}');
    print('[MakeHabit] Group ID: $groupId');
    selectedGroupId = groupId;
  }

  void onStep1Save(
    Map<int, bool> newWeeks,
    DateTime newWhatTime,
    List<Duration> newNoticeTimes,
  ) {
    print('[MakeHabit] Repeating weeks : ${newWeeks.toString()}');
    print('[MakeHabit] What time: $newWhatTime');
    print('[MakeHabit] Notification times: ${newNoticeTimes.toString()}');

    weeks = newWeeks;
    whatTime = newWhatTime;
    notificationTimes = newNoticeTimes;
  }
}
