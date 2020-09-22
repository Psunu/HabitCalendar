import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/make_habit_controller.dart';

class MakeHabit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MakeHabitController>(
      init: MakeHabitController(),
      builder: (controller) => Container(
        child: Column(
          children: [
            TextField(
              controller: controller.nameController,
              decoration: InputDecoration(
                hintText: '습관 이름',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
