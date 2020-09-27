import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/widgets/week_card.dart';

import '../controllers/make_habit_controller.dart';

class MakeHabit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<MakeHabitController>(
      init: MakeHabitController(),
      builder: (controller) => SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.nameController,
                      decoration: InputDecoration(
                        hintText: '습관 이름',
                        border: InputBorder.none,
                      ),
                      style: Get.textTheme.headline4
                          .copyWith(color: Colors.black87),
                    ),
                  ),
                  InkWell(
                    customBorder: const CircleBorder(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.5),
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(controller.selectedWeeksString),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: controller.buildWeekTiles(7),
              )
            ],
          ),
        ),
      ),
    );
  }
}
