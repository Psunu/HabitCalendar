import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

const _kCalendarHeight = 368.0;
const _kSliverAppBarHeight =
    _kCalendarHeight + _kMonthSpaceFromAppBar + _kProgressBarHeight + 32.0;
const _kScrolledSliverAppBarHeight = _kCalendarHeight * _kDateTileRatio +
    20.0 +
    _kScrolledProgressBarHeight +
    32.0;
const _kDateTileRatio = 1 / 6;

class CalendarView extends StatefulWidget {
  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView>
    with TickerProviderStateMixin {
  CalendarController _calendarController;
  TodayHabitController _todayHabitController;

  final _listKey = GlobalKey<SliverAnimatedListState>();
  bool _showFloatingCalendar = false;

  ScrollController _scrollController = ScrollController();

  AnimationController _monthController;
  Animation<RelativeRect> _monthPositionAnimation;
  Animation<double> _monthLargeCircleSizeAnimation;
  Animation<double> _monthSmallCircleSizeAnimation;
  Animation<double> _monthLargeTextSizeAnimation;
  Animation<double> _monthSmallTextSizeAnimation;
  Animation<double> _calendarSizeAnimation;
  Animation<double> _progressBarSizeAnimation;

  @override
  void initState() {
    _calendarController = CalendarController();
    _todayHabitController = TodayHabitController(listKey: _listKey);

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
      ),
    );
    _monthLargeCircleSizeAnimation = _monthController.drive(Tween(
      begin: _kNormalMonthLargeCircleSize,
      end: _kScrolledMonthLargeCircleSize,
    ))
      ..addListener(() {
        setState(() {});
      });
    _monthSmallCircleSizeAnimation = _monthController.drive(
      Tween(
        begin: _kNormalMonthSmallCircleSize,
        end: _kScrolledMonthSmallCircleSize,
      ),
    )..addListener(() {
        setState(() {});
      });
    _monthLargeTextSizeAnimation = _monthController.drive(Tween(
      begin: _kNormalMonthLargeTextSize,
      end: _kScrolledMonthLargeTextSize,
    ))
      ..addListener(() {
        setState(() {});
      });
    _monthSmallTextSizeAnimation = _monthController.drive(Tween(
      begin: _kNormalMonthSmallTextSize,
      end: _kScrolledMonthSmallTextSize,
    ))
      ..addListener(() {
        setState(() {});
      });
    _calendarSizeAnimation = _monthController.drive(
      Tween(begin: 1.0, end: _kDateTileRatio),
    );

    _progressBarSizeAnimation = _monthController.drive(
      Tween(begin: 1.0, end: _kScrolledProgressBarHeight / _kProgressBarHeight),
    );

    _scrollController.addListener(() {
      if (_scrollController.offset >= 0.0 &&
          _scrollController.offset <= _kMonthSpaceFromAppBar) {
        _monthController.value =
            _scrollController.offset / _kMonthSpaceFromAppBar;

        if (_showFloatingCalendar &&
            _scrollController.position.userScrollDirection ==
                ScrollDirection.forward) {
          setState(() {
            _showFloatingCalendar = false;
          });
        }
      } else if (!_showFloatingCalendar &&
          _scrollController.position.userScrollDirection ==
              ScrollDirection.reverse) {
        setState(() {
          _showFloatingCalendar = true;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _monthController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  Widget get _calendar {
    // Use Stack to show shadow of today week
    return Stack(
      children: [
        Padding(
          // Top padding for WeekHeader
          padding: const EdgeInsets.only(top: 20.0),
          child: GetX<CalendarController>(
            init: _calendarController,
            builder: (controller) => SizeTransition(
              sizeFactor: _calendarSizeAnimation,
              axisAlignment: controller.calendarAxisAlignment,
              child: Calendar.body(
                selectedDate: controller.selectedDate.value,
                onSelected: controller.onSelected,
                onBuildProgressBar: (DateTime date) => 0.5,
              ),
            ),
          ),
        ),
        Calendar.weekHeader(),
      ],
    );
  }

  Widget get _progressBar {
    return SizeTransition(
      sizeFactor: _progressBarSizeAnimation,
      child: GetX<TodayHabitController>(
        init: _todayHabitController,
        builder: (controller) => ProgressBar(
          percentage: controller.todayPercentage,
          backgroundColor: Colors.white,
          layoutPadding: Constants.padding * 2,
          height: _kProgressBarHeight,
        ),
      ),
    );
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
                  init: _todayHabitController,
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
                init: _calendarController,
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
            child: CustomScrollView(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Constants.padding,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: EdgeInsets.only(
                            top: _kMonthSpaceFromAppBar,
                            bottom: 32.0,
                          ),
                          child: _calendar,
                        ),
                        _progressBar,
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(top: 16.0),
                  sliver: GetX<TodayHabitController>(
                    init: _todayHabitController,
                    builder: (controller) => SliverAnimatedList(
                      key: _listKey,
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
                ),
              ],
            ),
          ),
        ),
        if (_showFloatingCalendar)
          Padding(
            padding: const EdgeInsets.only(
              left: Constants.padding,
              right: Constants.padding,
              top: _kRegularAppBarHeight,
            ),
            child: Container(
              color: Get.theme.scaffoldBackgroundColor,
              constraints: BoxConstraints(maxHeight: _kCalendarHeight),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: _calendar,
                  ),
                  _progressBar,
                ],
              ),
            ),
          )
        else
          Container(),
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
