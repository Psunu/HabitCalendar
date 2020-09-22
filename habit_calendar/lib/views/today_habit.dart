import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:habit_calendar/controllers/today_habit_controller.dart';
import 'package:habit_calendar/widgets/progress_bar.dart';

class TodayHabit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<TodayHabitController>(
      init: TodayHabitController(),
      builder: (controller) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Text(controller.formedToday),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                '꾸준히 하려면\n작게 해야 합니다',
                style: Get.textTheme.headline4.copyWith(color: Colors.black),
              ),
              const SizedBox(
                height: 100.0,
              ),
              //TODO test progress work properly
              ProgressBar(
                percentage: controller.todayPercentage,
                constraints:
                    BoxConstraints(maxWidth: context.width, maxHeight: 15.0),
              ),
              const SizedBox(
                height: 50.0,
              ),
              Column(
                children: _buildHabits(controller),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildHabits(TodayHabitController controller) {
    List<Widget> result = List<Widget>();
    controller.todayHabits.forEach((element) {
      result.add(Card(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          width: Get.context.width,
          height: 90.0,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  controller.formWhen(element.whatTime),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                child: VerticalDivider(),
              ),
              Expanded(
                flex: 4,
                child: Text(element.name),
              ),
            ],
          ),
        ),
      ));
    });

    return result;
  }
}
