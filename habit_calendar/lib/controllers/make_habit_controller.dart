import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/enums/day_of_the_week.dart';

import '../services/database/db_service.dart';

class MakeHabitController extends GetxController {
  final dbService = Get.find<DbService>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  List<DayOfTheWeek> selectedWeeks = List<DayOfTheWeek>();
}
