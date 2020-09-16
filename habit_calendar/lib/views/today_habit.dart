import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:habit_calendar/controllers/today_habit_controller.dart';

class TodayHabit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TodayHabitController>(
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
              const Text(
                '꾸준히 하려면\n작게해야 합니다',
              ),
              const SizedBox(
                height: 100.0,
              ),
              Stack(
                children: [
                  Container(
                    width: context.width,
                    height: 20.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  AnimatedContainer(
                    width: (context.width - 60.0) * controller.todayPercentage,
                    height: 20.0,
                    decoration: BoxDecoration(
                      color: context.theme.primaryColor,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    duration: Duration(
                      milliseconds: 200,
                    ),
                  ),
                ],
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
              Text(controller.formWhen(element.when)),
              SizedBox(
                width: 10.0,
              ),
              Text(element.name),
            ],
          ),
        ),
      ));
    });

    return result;
  }
}
