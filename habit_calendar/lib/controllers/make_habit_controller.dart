import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/widgets/week_card.dart';

import '../services/database/db_service.dart';

class MakeHabitController extends GetxController {
  final dbService = Get.find<DbService>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  Map<int, bool> selectedWeeks = Map<int, bool>().obs;

  //TODO implement function
  String get selectedWeeksString {
    if (selectedWeeks.isEmpty) return '';
    String result = '매주 ';

    selectedWeeks.forEach((key, value) {
      if (value) {
        result += getWeekString(key) + ', ';
      }
    });

    return result;
  }

  List<Widget> buildWeekTiles(int length) {
    return List.generate(length, (index) {
      return WeekCard(
        margin: EdgeInsets.symmetric(horizontal: 2.0),
        width: (Get.context.width - 68.0) / length,
        height: 60.0,
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
}
