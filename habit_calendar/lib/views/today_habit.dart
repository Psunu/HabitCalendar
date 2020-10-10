import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';

import 'package:habit_calendar/controllers/today_habit_controller.dart';
import 'package:habit_calendar/widgets/habit_tile.dart';
import 'package:habit_calendar/widgets/progress_bar.dart';

class TodayHabit extends StatefulWidget {
  @override
  _TodayHabitState createState() => _TodayHabitState();
}

class _TodayHabitState extends State<TodayHabit>
    with SingleTickerProviderStateMixin {
  AnimationController _rotationController;

  @override
  void initState() {
    _rotationController = AnimationController(
        duration: Duration(
          milliseconds: Constants.smallAnimationSpeed,
        ),
        vsync: this);

    super.initState();
  }

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
                children: List.generate(
                  controller.todayHabits.length,
                  (index) {
                    final element = controller.todayHabits[index];
                    return HabitTile(
                      key: ValueKey(element.id),
                      date: Text(controller.formWhatTime(element.whatTime)),
                      name: Text(element.name),
                      background: HabitTileBackground(
                        color: Get.theme.accentColor,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 30.0),
                          child: RotationTransition(
                            turns: Tween(begin: 0.0, end: -0.3).animate(
                              CurvedAnimation(
                                  parent: _rotationController,
                                  curve: Curves.ease),
                            ),
                            child: Icon(
                              Icons.check_circle_outline,
                              color: Get.theme.scaffoldBackgroundColor,
                              size: controller.backgroundAnimationTrigger.value
                                  ? 40.0
                                  : 30.0,
                            ),
                          ),
                        ),
                      ),
                      secondaryBackground: HabitTileBackground(
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 30.0),
                          child: RotationTransition(
                            turns: Tween(begin: 0.0, end: -0.3).animate(
                              CurvedAnimation(
                                  parent: _rotationController,
                                  curve: Curves.ease),
                            ),
                            child: Icon(
                              Icons.replay,
                              color: Get.theme.scaffoldBackgroundColor,
                              size: 30.0,
                            ),
                          ),
                        ),
                      ),
                      onBackgroundChangedAnimation: (from, to) async {
                        await _rotationController.forward();
                        return _rotationController.reverse();
                      },
                      onBackgroundChanged: (from, to) {
                        switch (from) {
                          case HabitTileBackgroundType.background:
                            controller.complete(element.id);
                            break;
                          case HabitTileBackgroundType.secondaryBackground:
                            controller.notComplete(element.id);
                            break;
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
