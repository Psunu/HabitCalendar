import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/controllers/calendar_controller.dart';
import 'package:habit_calendar/controllers/today_habit_controller.dart';
import 'package:habit_calendar/views/make_habit_view.dart';
import 'package:habit_calendar/widgets/general/auto_colored_text.dart';
import 'package:habit_calendar/widgets/general/auto_colored_widget.dart';
import 'package:habit_calendar/widgets/project/calendar.dart';
import 'package:habit_calendar/widgets/project/flat_action_button.dart';

import '../widgets/general/progress_bar.dart';

const _kRegularAppBarHeight = 56.0;
const _kProgressBarHeight = 12.0;
const _kScrolledProgressBarHeight = 7.0;

const _kMyHabitHeight = 34.0;
const _kMyHabitWidth = 76.0;
const _kMyHabitMargin = (_kRegularAppBarHeight - _kMyHabitHeight) / 2;

const _kNormalMonthLargeCircleSize = 58.0;
const _kScrolledMonthLargeCircleSize = 37.0;
const _kNormalMonthSmallCircleSize = 42.0;
const _kScrolledMonthSmallCircleSize = 27.0;
const _kNormalMonthLargeTextSize = 28.0;
const _kScrolledMonthLargeTextSize = 16.0;
const _kNormalMonthSmallTextSize = 16.0;
const _kScrolledMonthSmallTextSize = 9.0;
const _kMonthSpaceFromAppBar = 97.0 - _kMyHabitMargin;
const _kNormalMonthTopPadding = _kMyHabitHeight + _kMyHabitMargin + 16.0;
const _kScrolledMonthTopPadding = 8.0;

const _kDateTileRatio = 1 / 6;

class CalendarView extends StatefulWidget {
  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView>
    with TickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  AnimationController _monthController;
  Animation _monthPositionAnimation;
  Animation _monthLargeCircleSizeAnimation;
  Animation _monthSmallCircleSizeAnimation;
  Animation _monthLargeTextSizeAnimation;
  Animation _monthSmallTextSizeAnimation;
  Animation _calendarSizeAnimation;
  Animation _progressBarSizeAnimation;

  @override
  void initState() {
    _monthController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: Constants.mediumAnimationSpeed,
      ),
    );
    _monthPositionAnimation = _monthController.drive(
      RelativeRectTween(
        begin: RelativeRect.fromLTRB(
            (Get.width / 2) - (_kNormalMonthLargeCircleSize / 2),
            _kNormalMonthTopPadding,
            0.0,
            0.0),
        end: RelativeRect.fromLTRB(
            (Get.width / 2) - (_kScrolledMonthLargeCircleSize / 2),
            _kScrolledMonthTopPadding,
            0.0,
            0.0),
      ).chain(CurveTween(curve: Curves.ease)),
    );
    _monthLargeCircleSizeAnimation = _monthController.drive(
      Tween(
        begin: _kNormalMonthLargeCircleSize,
        end: _kScrolledMonthLargeCircleSize,
      ).chain(CurveTween(curve: Curves.ease)),
    )..addListener(() {
        setState(() {});
      });
    _monthSmallCircleSizeAnimation = _monthController.drive(
      Tween(
        begin: _kNormalMonthSmallCircleSize,
        end: _kScrolledMonthSmallCircleSize,
      ).chain(CurveTween(curve: Curves.ease)),
    )..addListener(() {
        setState(() {});
      });
    _monthLargeTextSizeAnimation = _monthController.drive(
      Tween(
        begin: _kNormalMonthLargeTextSize,
        end: _kScrolledMonthLargeTextSize,
      ).chain(CurveTween(curve: Curves.ease)),
    )..addListener(() {
        setState(() {});
      });
    _monthSmallTextSizeAnimation = _monthController.drive(
      Tween(
        begin: _kNormalMonthSmallTextSize,
        end: _kScrolledMonthSmallTextSize,
      ).chain(CurveTween(curve: Curves.ease)),
    )..addListener(() {
        setState(() {});
      });
    _calendarSizeAnimation = _monthController.drive(
      Tween(begin: 1.0, end: _kDateTileRatio)
          .chain(CurveTween(curve: Curves.ease)),
    );

    _progressBarSizeAnimation = _monthController.drive(
      Tween(begin: 1.0, end: _kScrolledProgressBarHeight / _kProgressBarHeight)
          .chain(CurveTween(curve: Curves.ease)),
    );

    _scrollController.addListener(() {
      if (_scrollController.offset >= 0.0 &&
          _scrollController.offset <= _kMonthSpaceFromAppBar) {
        _monthController.value =
            _scrollController.offset / _kMonthSpaceFromAppBar;
      }
    });

    super.initState();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (details.primaryDelta.sign < 0) {
      _monthController.forward();
    } else if (details.primaryDelta.sign > 0) {
      _monthController.reverse();
    }
  }

  @override
  void dispose() {
    _monthController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Get.theme.scaffoldBackgroundColor,
            elevation: 0.0,
            titleSpacing: 0.0,
            title: Padding(
              padding: const EdgeInsets.only(left: Constants.padding),
              child: SizedBox(
                width: _kMyHabitWidth,
                height: _kMyHabitHeight,
                child: GetBuilder<TodayHabitController>(
                  init: TodayHabitController(),
                  builder: (controller) => RaisedButton(
                    onPressed: controller.navigateToManage,
                    color: Get.theme.accentColor,
                    padding: const EdgeInsets.all(0.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Constants.largeBorderRadius,
                      ),
                    ),
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
            ),
            actions: [
              GetBuilder<CalendarController>(
                init: CalendarController(),
                builder: (controller) => Padding(
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
                        controller.today.year.toString(),
                        style: Get.textTheme.bodyText1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Container(
            height: Get.height,
            color: Get.theme.scaffoldBackgroundColor,
            child: Column(
              children: [
                // Calendar
                GestureDetector(
                  onVerticalDragUpdate: _onVerticalDragUpdate,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top:
                          _kMonthSpaceFromAppBar * _calendarSizeAnimation.value,
                      left: Constants.padding,
                      right: Constants.padding,
                      bottom: 32.0,
                    ),
                    // Use Stack to show shadow of today week
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: GetX<CalendarController>(
                            init: CalendarController(),
                            builder: (controller) => SizeTransition(
                              sizeFactor: _calendarSizeAnimation,
                              axisAlignment: controller.calendarAxisAlignment,
                              child: Calendar.body(
                                month: controller.selectedMonth,
                                startWeek: controller.startWeek,
                                onSelected: controller.onSelected,
                                onBuildProgressBar:
                                    controller.onBuildProgressBar,
                              ),
                            ),
                          ),
                        ),
                        GetBuilder<CalendarController>(
                          init: CalendarController(),
                          builder: (controller) => Calendar.weekHeader(
                            startWeek: controller.startWeek,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: Constants.padding,
                    right: Constants.padding,
                  ),
                  child: GetX<TodayHabitController>(
                    init: TodayHabitController(),
                    builder: (controller) => SizeTransition(
                      sizeFactor: _progressBarSizeAnimation,
                      child: ProgressBar(
                        percentage: controller.todayPercentage,
                        backgroundColor: Colors.white,
                        layoutPadding: Constants.padding * 2,
                        height: _kProgressBarHeight,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: CustomScrollView(
//                    controller: _scrollController,
                    physics: BouncingScrollPhysics(),
                    slivers: [
//                    SliverPadding(
//                      padding: const EdgeInsets.only(
//                        top: _kMonthSpaceFromAppBar,
//                        left: Constants.padding,
//                        right: Constants.padding,
//                        bottom: 32.0,
//                      ),
//                      sliver: SliverList(
//                        delegate: SliverChildListDelegate(
//                          [
//                            // Use Stack to show shadow of today week
//                            Stack(
//                              children: [
//                                Padding(
//                                  padding: const EdgeInsets.only(top: 20.0),
//                                  child: Calendar.body(
//                                    onBuildProgressBar: (DateTime date) => 0.5,
//                                  ),
//                                ),
//                                Calendar.weekHeader(),
//                              ],
//                            )
//                          ],
//                        ),
//                      ),
//                    ),
//                      SliverPadding(
//                        padding: const EdgeInsets.only(
//                          left: Constants.padding,
//                          right: Constants.padding,
//                          bottom: 16.0,
//                        ),
//                        sliver: SliverList(
//                            delegate: SliverChildListDelegate([
//                          GetX<TodayHabitController>(
//                            init: TodayHabitController(),
//                            builder: (controller) => ProgressBar(
//                              percentage: controller.todayPercentage,
//                              backgroundColor: Colors.white,
//                              layoutPadding: Constants.padding * 2,
//                              height: _kProgressBarHeight,
//                            ),
//                          ),
//                        ])),
//                      ),
                      SliverPadding(
                        padding: const EdgeInsets.only(top: 16.0),
                        sliver: GetX<TodayHabitController>(
                          init: TodayHabitController(),
                          builder: (controller) => SliverAnimatedList(
                            key: controller.listKey,
                            initialItemCount: controller.todayHabits.length,
                            itemBuilder: (context, index, animation) {
                              final habit = controller.todayHabits[index];
                              controller.animationControllers[habit.id] =
                                  AnimationController(
                                      duration: Duration(
                                        milliseconds:
                                            Constants.smallAnimationSpeed,
                                      ),
                                      vsync: this);

                              return controller.buildItem(habit, animation);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        PositionedTransition(
          rect: _monthPositionAnimation,
          child: Calendar.header(
            largeCircleColor: Get.theme.accentColor,
            smallCircleColor: Get.theme.primaryColor,
            largeCircleSize: _monthLargeCircleSizeAnimation.value,
            smallCircleSize: _monthSmallCircleSizeAnimation.value,
            largeChild: AutoColoredWidget(
              backgroundColor: Get.theme.accentColor,
              child: Text(
                '11',
                style: Get.textTheme.headline4.copyWith(
                  fontSize: _monthLargeTextSizeAnimation.value,
                ),
              ),
            ),
            smallChild: AutoColoredWidget(
              backgroundColor: Get.theme.primaryColor,
              child: Text(
                '월',
                style: Get.textTheme.bodyText1.copyWith(
                  fontSize: _monthSmallTextSizeAnimation.value,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
