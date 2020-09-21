import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/make_habit_controller.dart';

// TODO implement make habit view
class MakeHabit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MakeHabitController>(
      init: MakeHabitController(),
      builder: (controller) => Container(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
