import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/widgets/week_card.dart';

import '../services/database/db_service.dart';

class MakeHabitController extends GetxController {
  final dbService = Get.find<DbService>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  final weekCardHeight = 60.0;

  final selectedWeeks = Map<int, bool>().obs;
  int weeksLength = 7;

  final whatTimeActivated = false.obs;
  final notificationActivated = false.obs;
  final descriptionActivated = false.obs;

  String get selectedWeeksString {
    if (selectedWeeks.isEmpty) return '반복할 요일을 선택해 주세요';

    int falses = 0;
    int trues = 0;

    String result = '매주';

    selectedWeeks.forEach((key, value) {
      if (value) {
        result += ' ' + getWeekString(key) + ',';
        trues++;
      } else {
        falses++;
      }
    });

    if (falses == selectedWeeks.length) return '반복할 요일을 선택해 주세요';
    if (trues == weeksLength) return '매일';
    return result.replaceRange(result.length - 1, result.length, '');
  }

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
          getWeekString(index),
        ),
        onTapped: (selected) {
          selectedWeeks[index] = selected;
        },
      );
    });
  }

  String getWeekString(int week) {
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

  Future<void> save() {}
}
