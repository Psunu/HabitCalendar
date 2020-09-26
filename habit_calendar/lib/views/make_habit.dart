import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/widgets/week_card.dart';

import '../controllers/make_habit_controller.dart';

class MakeHabit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MakeHabitController>(
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
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.5),
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildWeekTiles(),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildWeekTiles() {
    return List.generate(7, (index) {
      return WeekCard(
        margin: EdgeInsets.symmetric(horizontal: 2.0),
        width: (Get.context.width - 68.0) / 7,
        height: 60.0,
        child: Text(
          _getWeekString(index),
        ),
      );
    });
  }

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
}
