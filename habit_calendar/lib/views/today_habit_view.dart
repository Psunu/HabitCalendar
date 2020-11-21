import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/controllers/today_habit_controller.dart';
import 'package:habit_calendar/views/make_habit_view.dart';
import 'package:habit_calendar/widgets/general_purpose/auto_colored_text.dart';
import 'package:habit_calendar/widgets/general_purpose/auto_colored_widget.dart';
import 'package:habit_calendar/widgets/project_purpose/custom_chip.dart';
import 'package:habit_calendar/widgets/project_purpose/flat_action_button.dart';

import '../widgets/general_purpose/progress_bar.dart';

const _kRegualAppBarHeight = 56.0;
const _kflexibleSpace = 146.0;
const _kProgressBarHeight = 12.0;
const _kMyHabitHeight = 34.0;
const _kMyHabitWidth = 76.0;

double get _myHabitMargin => (_kRegualAppBarHeight - _kMyHabitHeight) / 2;

class TodayHabitView extends StatefulWidget {
  @override
  _TodayHabitViewState createState() => _TodayHabitViewState();
}

class _TodayHabitViewState extends State<TodayHabitView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      color: Get.theme.scaffoldBackgroundColor,
      child: GetX<TodayHabitController>(
        init: TodayHabitController(),
        builder: (controller) => CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              collapsedHeight: _kRegualAppBarHeight + 23.0 - _myHabitMargin,
              expandedHeight:
                  _kflexibleSpace + _kRegualAppBarHeight + _kProgressBarHeight,
              backgroundColor: Get.theme.scaffoldBackgroundColor,
              elevation: 0.0,
              titleSpacing: 0.0,
              title: Padding(
                padding: const EdgeInsets.only(left: Constants.padding),
                child: GestureDetector(
                  onTap: controller.navigateToManage,
                  child: CustomChip(
                    width: _kMyHabitWidth,
                    height: _kMyHabitHeight,
                    elevation: 5.0,
                    padding: const EdgeInsets.all(0.0),
                    color: Get.theme.accentColor,
                    child: Center(
                      child: AutoColoredText(
                        backgroundColor: Get.theme.accentColor,
                        child: Text(
                          '내 습관'.tr.capitalizeFirst,
                          style: Get.textTheme.bodyText1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: Constants.padding),
                  child: FlatActionButton(
                    onTap: () => Get.to(MakeHabitView()),
                    icon: AutoColoredWidget(
                      backgroundColor: Get.theme.scaffoldBackgroundColor,
                      child: Icon(
                        Icons.add,
                      ),
                    ),
                    text: AutoColoredWidget(
                      backgroundColor: Get.theme.scaffoldBackgroundColor,
                      child: Text(
                        '새 습관',
                        style: Get.textTheme.bodyText1,
                      ),
                    ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.only(
                    top: _kRegualAppBarHeight + 35.0,
                    left: Constants.padding,
                    right: Constants.padding,
                    bottom: _kProgressBarHeight + 23.0,
                  ),
                  child: AutoColoredText(
                    backgroundColor: Get.theme.scaffoldBackgroundColor,
                    child: Text(
                      '꾸준히 하려면\n작게 해야 합니다'.tr,
                      style: Get.textTheme.headline4,
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(_kProgressBarHeight),
                child: ProgressBar(
                  percentage: controller.todayPercentage,
                  backgroundColor: Colors.white,
                  layoutPadding: Constants.padding * 2,
                  height: _kProgressBarHeight,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 46.0),
              sliver: SliverAnimatedList(
                key: controller.listKey,
                initialItemCount: controller.todayHabits.length,
                itemBuilder: (context, index, animation) {
                  final habit = controller.todayHabits[index];
                  controller.animationControllers[habit.id] =
                      AnimationController(
                          duration: Duration(
                            milliseconds: Constants.smallAnimationSpeed,
                          ),
                          vsync: this);

                  return controller.buildItem(habit, animation);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
