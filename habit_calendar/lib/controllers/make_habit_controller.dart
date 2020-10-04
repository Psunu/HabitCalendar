import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/widgets/week_card.dart';

import '../services/database/db_service.dart';

class MakeHabitController extends GetxController {
  final dbService = Get.find<DbService>();

  // TextField Controllers
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  // Weeks input
  final selectedWeeks = Map<int, bool>().obs;
  int weeksLength = 7;

  // Times input
  final whatTime = DateTime(0, 0, 0, 0, 0).obs;
  final notificationTime = Duration().obs;

  // Ativation variables
  final isWhatTimeActivated = false.obs;
  final isNotificationActivated = false.obs;
  final isDescriptionActivated = false.obs;

  // settings
  final weekCardHeight = 60.0;

  // Get Set
  String get selectedWeeksString {
    whatTime.value.toString();
    if (selectedWeeks.isEmpty) return '반복할 요일을 선택해 주세요';

    int falses = 0;
    int trues = 0;

    String result = '매주';

    selectedWeeks.forEach((key, value) {
      if (value) {
        result += ' ' + _getWeekString(key) + ',';
        trues++;
      } else {
        falses++;
      }
    });

    if (falses == selectedWeeks.length) return '반복할 요일을 선택해 주세요';
    if (trues == weeksLength) return '매일';
    return result.replaceRange(result.length - 1, result.length, '');
  }

  String get whatTimeString {
    String result;

    if (whatTime.value.hour < 12) {
      result = '오전 ';
      result += _twoDigits(whatTime.value.hour);
    } else {
      result = '오후 ';
      if (whatTime.value.hour > 12)
        result += _twoDigits(whatTime.value.hour - 12).toString();
      else
        result += _twoDigits(whatTime.value.hour);
    }

    result += ' : ${_twoDigits(whatTime.value.minute)}';

    return result;
  }

  String get notificationTimeString {
    int hours = notificationTime.value.inHours;
    int minutes = (notificationTime.value - Duration(hours: hours)).inMinutes;

    String result = '';

    if (hours > 0) {
      result += '$hours 시간 ';
    } else if (minutes < 1) {
      return '즉시 알림';
    }
    result += '$minutes 분 전에 알림';

    return result;
  }

  // Methods
  List<Widget> buildWeekTiles(int length) {
    weeksLength = length;
    EdgeInsets margin = const EdgeInsets.only(right: 2.0);
    return List.generate(length, (index) {
      if (index == length - 1)
        margin = const EdgeInsets.only(left: 2.0);
      else if (index != 0) margin = const EdgeInsets.symmetric(horizontal: 2.0);

      return WeekCard(
        margin: margin,
        width: (Get.context.width - 68.0) / length,
        height: weekCardHeight,
        child: Text(
          _getWeekString(index),
        ),
        onTapped: (selected) {
          selectedWeeks[index] = selected;
        },
      );
    });
  }

  Future<void> save() async {
    int id = await dbService.database.habitDao.insertHabit(
      Habit(
        id: null,
        name: nameController.text,
        statusBarFix: null,
        groupId: null,
        notificationTypeId: null,
        notificationTime: notificationTime.value.inMinutes,
        whatTime: whatTime.value,
        description: descriptionController.text,
      ),
    );
    selectedWeeks.forEach((key, value) async {
      if (value) {
        await dbService.database.habitWeekDao
            .insertHabitWeek(HabitWeek(habitId: id, week: key));
      }
    });
  }

  // local method
  String _getWeekString(int week) {
    switch (week) {
      case 0:
        return '월';
      case 1:
        return '화';
      case 2:
        return '수';
      case 3:
        return '목';
      case 4:
        return '금';
      case 5:
        return '토';
      case 6:
        return '일';
    }
    return '월';
  }

  static String _twoDigits(int n) {
    if (n >= 10) return "${n}";
    return "0${n}";
  }
}
