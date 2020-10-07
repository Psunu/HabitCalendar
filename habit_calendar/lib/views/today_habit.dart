import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';

import 'package:habit_calendar/controllers/today_habit_controller.dart';
import 'package:habit_calendar/widgets/progress_bar.dart';

class TodayHabit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<TodayHabitController>(
      init: TodayHabitController(),
      builder: (controller) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(
            Constants.padding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Text(controller.formedToday),
              ),
              const SizedBox(
                height: 40.0,
              ),
              Text(
                '꾸준히 하려면\n작게 해야 합니다',
                style: Get.textTheme.headline4,
              ),
              const SizedBox(
                height: 50.0,
              ),
              ProgressBar(
                percentage: controller.todayPercentage,
                constraints: BoxConstraints(
                    maxWidth: context.width - 60.0, maxHeight: 15.0),
              ),
              const SizedBox(
                height: 50.0,
              ),
              Column(
                children: controller.buildHabits(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
