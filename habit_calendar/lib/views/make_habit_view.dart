import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/controllers/make_habit_controller.dart';
import 'package:habit_calendar/widgets/general_purpose/auto_colored_icon.dart';
import 'package:habit_calendar/widgets/project_purpose/make_steps.dart';

class MakeHabitView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        elevation: 0.0,
        leading: IconButton(
          icon: AutoColoredIcon(
            child: Icon(Icons.arrow_back),
            backgroundColor: Get.theme.scaffoldBackgroundColor,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Constants.padding),
        child: GetX<MakeHabitController>(
          init: MakeHabitController(),
          builder: (controller) => MakeSteps(
            habits: controller.habits.toList(),
            groups: controller.groups.toList(),
            insertGroup: controller.dbService.database.groupDao.insertGroup,
            onSave: controller.onSave,
          ),
        ),
      ),
    );
  }
}
