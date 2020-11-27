import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/controllers/calendar_controller.dart';
import 'package:habit_calendar/controllers/today_habit_controller.dart';
import 'package:habit_calendar/utils/utils.dart';
import 'package:habit_calendar/widgets/general/auto_colored_text.dart';
import 'package:habit_calendar/widgets/general/auto_colored_widget.dart';
import 'package:habit_calendar/widgets/general/selector.dart';
import 'package:habit_calendar/widgets/project/bottom_buttons.dart';
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

const _kCalendarHeight = 348.0;
const _kCalendarWeekHeight = 20.0;
const _kSliverAppBarHeight = _kCalendarHeight +
    _kCalendarWeekHeight +
    _kMonthSpaceFromAppBar +
    _kProgressBarHeight +
    32.0;
const _kScrolledSliverAppBarHeight = _kCalendarHeight * _kDateTileRatio +
    _kCalendarWeekHeight +
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
  ScrollController _scrollController = ScrollController();
  PageController _fullCalendarPageController =
      PageController(initialPage: 1000);
  PageController _weekCalendarPageController =
      PageController(initialPage: 1000);

  AnimationController _animationController;
  Animation<double> _calendarTopPaddingAnimation;
  Animation<double> _calendarSizeAnimation;
  Animation<double> _progressBarSizeAnimation;

  double _percentage = 0.0;
  bool get _showWeekCalendar =>
      _animationController.status == AnimationStatus.completed;

  final _listKey = GlobalKey<SliverAnimatedListState>();

  @override
  void initState() {
    _calendarController = CalendarController(
      fullCalendarPageController: _fullCalendarPageController,
      weekCalendarPageController: _weekCalendarPageController,
    );
    _todayHabitController = TodayHabitController(listKey: _listKey);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: Constants.mediumAnimationSpeed,
      ),
    );

    _calendarTopPaddingAnimation = _animationController.drive(
      Tween(begin: 1.0, end: 0.0),
    );

    _calendarSizeAnimation = _animationController.drive(
      Tween(begin: 1.0, end: _kDateTileRatio),
    );

    _progressBarSizeAnimation = _animationController.drive(
      Tween(begin: 1.0, end: _kScrolledProgressBarHeight / _kProgressBarHeight),
    );

    _scrollController.addListener(() {
      setState(() {
        _animationController.value = _percentage;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    _fullCalendarPageController.dispose();
    _weekCalendarPageController.dispose();

    super.dispose();
  }

  Widget get _fullCalendar {
    return GetX<CalendarController>(
      init: _calendarController,
      builder: (controller) => SizeTransition(
        sizeFactor: _calendarSizeAnimation,
        axisAlignment: controller.calendarAxisAlignment,
        child: SizedBox(
          height: _kCalendarHeight,
          child: PageView.builder(
            controller: _fullCalendarPageController,
            onPageChanged: controller.onFullCalendarPageChanged,
            itemBuilder: (context, index) => Calendar.body(
              month: controller.getMonthByFullCalendarIndex(index),
              selectedDate: controller.selectedDate.value,
              onSelected: controller.onSelectedInFullCalendar,
              onBuildProgressBar: controller.onBuildProgressBar,
            ),
          ),
        ),
      ),
    );
  }

  Widget get _weekCalendar {
    return GetX<CalendarController>(
      init: _calendarController,
      builder: (controller) => SizedBox(
        height: Calendar.dateHeightWithPadding,
        child: PageView.builder(
          controller: _weekCalendarPageController,
          onPageChanged: controller.onWeekCalendarPageChanged,
          itemBuilder: (context, index) => Calendar.weekBody(
            month: controller.selectedMonth,
            week: controller.getWeekByWeekCalendarIndex(index),
            selectedDate: controller.selectedDate.value,
            onSelected: controller.onSelectedInWeekCalendar,
            onBuildProgressBar: controller.onBuildProgressBar,
          ),
        ),
      ),
    );
  }

  Widget get _calendar {
    // Use Stack to show shadow of today week
    return Stack(
      children: [
        Padding(
          // Top padding for WeekHeader
          padding: const EdgeInsets.only(top: _kCalendarWeekHeight),
          child: _showWeekCalendar ? _weekCalendar : _fullCalendar,
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

  void _onPointerUp(PointerUpEvent event) {
    final duration = Duration(milliseconds: Constants.mediumAnimationSpeed);
    final curve = Curves.ease;

    if (_animationController.value == 1.0 || _animationController.value == 0.0)
      return;

    if (_animationController.value < 0.7) {
      _scrollController.animateTo(0.0, duration: duration, curve: curve);
    } else {
      _scrollController.animateTo(
        _kSliverAppBarHeight - _kScrolledSliverAppBarHeight,
        duration: duration,
        curve: curve,
      );
    }
  }

  void _showChangeDateModal(DateTime selectedDate) {
    final header = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Calendar.header(
          largeCircleSize: _kScrolledMonthLargeCircleSize,
          smallCircleSize: _kScrolledMonthSmallCircleSize,
          largeCircleColor: Get.theme.accentColor,
          smallCircleColor: Get.theme.primaryColor,
          centerChild: AutoColoredWidget(
            backgroundColor: Get.theme.accentColor,
            child: Icon(Icons.date_range_rounded),
          ),
        ),
        SizedBox(width: 5.0),
        Text(
          '${selectedDate.year}.${selectedDate.month}',
          style: Get.textTheme.bodyText1,
        )
      ],
    );

    final selectedStyle = Get.textTheme.bodyText1.copyWith(
      color: Get.theme.primaryColor,
      fontWeight: FontWeight.bold,
    );

    final body = Row(
      children: [
        Selector(
          items: ['2020', '2021'],
          selectedStyle: selectedStyle,
          unselectedStyle: Selector.getUnselectedStyle(Get.textTheme.bodyText1),
        ),
        Selector(
            items: ['1', '2', '3'],
            selectedStyle: selectedStyle,
            unselectedStyle:
                Selector.getUnselectedStyle(Get.textTheme.bodyText1)),
      ],
    );

    final bottom = BottomButtons(
      // spaceBetween: true,
      margin: const EdgeInsets.all(0.0),
    );

    Utils.customShowModal(
      builder: (BuildContext context) {
        return Column(
          children: [
            header,
            body,
            bottom,
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
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
              GetX<CalendarController>(
                init: _calendarController,
                builder: (controller) => Padding(
                  padding: const EdgeInsets.only(right: Constants.padding),
                  child: FlatActionButton(
                    onTap: () => _showChangeDateModal(
                      controller.selectedDate.value,
                    ),
                    icon: AutoColoredWidget(
                      backgroundColor: Get.theme.scaffoldBackgroundColor,
                      child: Icon(
                        Icons.date_range_rounded,
                      ),
                    ),
                    text: AutoColoredWidget(
                      backgroundColor: Get.theme.scaffoldBackgroundColor,
                      child: Text(
                        controller.selectedDate.value.year.toString(),
                        style: Get.textTheme.bodyText1,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Listener(
            onPointerUp: _onPointerUp,
            child: Container(
              height: Get.height,
              color: Get.theme.scaffoldBackgroundColor,
              child: CustomScrollView(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: _kSliverAppBarHeight,
                    toolbarHeight: _kScrolledSliverAppBarHeight,
                    backgroundColor: Get.theme.scaffoldBackgroundColor,
                    elevation: 0.0,
                    flexibleSpace: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        _percentage = 1.0 -
                            (constraints.maxHeight -
                                    _kScrolledSliverAppBarHeight) /
                                (_kSliverAppBarHeight -
                                    _kScrolledSliverAppBarHeight);

                        _animationController.value = _percentage;

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Constants.padding,
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: _kMonthSpaceFromAppBar *
                                    _calendarTopPaddingAnimation.value,
                              ),
                              _calendar,
                              SizedBox(height: 32.0),
                              _progressBar,
                            ],
                          ),
                        );
                      },
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
        ),
        Positioned(
          top: (_kNormalMonthTopPadding -
              (_kNormalMonthTopPadding - _kScrolledMonthTopPadding) *
                  _percentage),
          child: GetX<CalendarController>(
            init: _calendarController,
            builder: (controller) => Calendar.header(
              largeCircleColor: Get.theme.accentColor,
              smallCircleColor: Get.theme.primaryColor,
              largeCircleSize: (_kNormalMonthLargeCircleSize) -
                  (_kNormalMonthLargeCircleSize -
                          _kScrolledMonthLargeCircleSize) *
                      _percentage,
              smallCircleSize: (_kNormalMonthSmallCircleSize) -
                  (_kNormalMonthSmallCircleSize -
                          _kScrolledMonthSmallCircleSize) *
                      _percentage,
              largeChild: AutoColoredWidget(
                backgroundColor: Get.theme.accentColor,
                child: Text(
                  controller.selectedMonth.month.toString(),
                  style: Get.textTheme.headline4.copyWith(
                    fontSize: (_kNormalMonthLargeTextSize) -
                        (_kNormalMonthLargeTextSize -
                                _kScrolledMonthLargeTextSize) *
                            _percentage,
                  ),
                ),
              ),
              smallChild: AutoColoredWidget(
                backgroundColor: Get.theme.primaryColor,
                child: Text(
                  '월',
                  style: Get.textTheme.bodyText1.copyWith(
                    fontSize: (_kNormalMonthSmallTextSize) -
                        (_kNormalMonthSmallTextSize -
                                _kScrolledMonthSmallTextSize) *
                            _percentage,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
