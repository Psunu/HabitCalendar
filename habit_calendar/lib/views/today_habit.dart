import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';

import 'package:habit_calendar/controllers/today_habit_controller.dart';
import 'package:habit_calendar/widgets/progress_bar.dart';

class TodayHabit extends StatefulWidget {
  @override
  _TodayHabitState createState() => _TodayHabitState();
}

class _TodayHabitState extends State<TodayHabit> with TickerProviderStateMixin {
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
            top: Constants.padding,
            bottom: Constants.padding + 40.0,
            left: Constants.padding,
            right: Constants.padding,
          ),

          /// Basically it has top content at index 0.
          /// it should be todayHabits.length + 1.
          /// and when build HabitTile. use index - 1.
          initialItemCount: controller.todayHabits.length + 1,
          itemBuilder: (context, index, animation) {
            // Top Content
            if (index == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     InkWell(
                  //       onTap: controller.navigateToManage,
                  //       child: Icon(
                  //         Icons.menu,
                  //         // color: Get.theme.accentColor,
                  //       ),
                  //     ),
                  //     // IconButton(
                  //     //   alignment: Alignment.centerLeft,
                  //     //   padding: EdgeInsets.all(0.0),
                  //     //   icon: Icon(
                  //     //     Icons.menu,
                  //     //   ),
                  //     //   onPressed: controller.navigateToManage,
                  //     // ),
                  //     Text(
                  //       controller.formedToday,
                  //       style: Get.textTheme.bodyText2,
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(
                  //   height: Constants.padding,
                  // ),
                  Text(
                    '꾸준히 하려면\n작게 해야 합니다',
                    style: Get.textTheme.headline4,
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  ProgressBar(
                    percentage: controller.todayPercentage,
                    layoutPadding: Constants.padding * 2,
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                ],
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
