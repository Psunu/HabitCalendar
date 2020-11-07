import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/controllers/today_habit_controller.dart';

import '../widgets/general_purpose/progress_bar.dart';

class TodayHabitView extends StatefulWidget {
  @override
  _TodayHabitViewState createState() => _TodayHabitViewState();
}

class _TodayHabitViewState extends State<TodayHabitView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return GetX<TodayHabitController>(
      init: TodayHabitController(),
      builder: (controller) => Container(
        height: Get.height,
        child: AnimatedList(
          key: controller.listKey,
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.only(
            bottom: Constants.padding + 50.0,
          ),

          /// Basically it has top content at index 0.
          /// it should be todayHabits.length + 1.
          /// and when build HabitTile. use index - 1.
          initialItemCount: controller.todayHabits.length + 1,
          itemBuilder: (context, index, animation) {
            // Top Content
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(
                  top: Constants.padding,
                  left: Constants.padding,
                  right: Constants.padding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '꾸준히 하려면\n작게 해야 합니다'.tr,
                      style: Get.textTheme.headline5,
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    ProgressBar(
                      percentage: controller.todayPercentage,
                      layoutPadding: Constants.padding * 2,
                      height: 12.0,
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                  ],
                ),
              );
            }

            final habit = controller.todayHabits[index - 1];
            controller.animationControllers[habit.id] = AnimationController(
                duration: Duration(
                  milliseconds: Constants.smallAnimationSpeed,
                ),
                vsync: this);

            // Habit tiles
            return controller.buildItem(habit, animation);
          },
        ),
      ),
    );
  }
}
