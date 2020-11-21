import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/enums/day_of_the_week.dart';
import 'package:habit_calendar/utils/utils.dart';
import 'package:habit_calendar/widgets/general/auto_colored_widget.dart';
import 'package:habit_calendar/widgets/general/progress_bar.dart';

// Related with Header
const _kHeaderLargeCircleSize = 58.0;
const _kHeaderSmallCircleSize = 42.0;
const _kHeaderCircleVerticalSpaceRatio =
    23 / (_kHeaderLargeCircleSize - _kHeaderSmallCircleSize);
const _kHeaderCircleHorizontalSpaceRatio =
    28 / (_kHeaderLargeCircleSize - _kHeaderSmallCircleSize);

// Related with WeekHeader
const _kWeekNormalHeight = 20.0;
const _kWeekTodayHeight = 24.0;
const _kWeekTodayElevation = 3.0;

// Related with Body
const _kDateTileHeight = 42.0;

DateTime _zeroDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

class Calendar extends StatelessWidget {
  Calendar({
    Key key,
    this.largeCircleSize = _kHeaderLargeCircleSize,
    this.smallCircleSize = _kHeaderSmallCircleSize,
    this.largeCircleColor,
    this.smallCircleColor,
    this.largeChild,
    this.smallChild,
    this.weekdayColor,
    this.weekendColor,
    this.startWeek = DayOfTheWeek.Sun,
    this.onSelected,
    this.onBuildProgressBar,
  }) : super(key: key);

  final double largeCircleSize;
  final double smallCircleSize;
  final Color largeCircleColor;
  final Color smallCircleColor;
  final Widget largeChild;
  final Widget smallChild;

  final Color weekdayColor;
  final Color weekendColor;
  final DayOfTheWeek startWeek;

  final Function(DateTime) onSelected;
  final double Function(DateTime) onBuildProgressBar;

  static _Header header({
    Key key,
    double largeCircleSize = _kHeaderLargeCircleSize,
    double smallCircleSize = _kHeaderSmallCircleSize,
    Color largeCircleColor,
    Color smallCircleColor,
    Widget largeChild,
    Widget smallChild,
  }) {
    return _Header(
      key: key,
      largeCircleSize: largeCircleSize,
      smallCircleSize: smallCircleSize,
      largeCircleColor: largeCircleColor,
      smallCircleColor: smallCircleColor,
      largeChild: largeChild,
      smallChild: smallChild,
    );
  }

  static _WeekHeader weekHeader({
    Key key,
    Color weekdayColor,
    Color weekendColor,
    DayOfTheWeek startWeek = DayOfTheWeek.Sun,
  }) {
    return _WeekHeader(
      key: key,
      weekdayColor: weekdayColor,
      weekendColor: weekendColor,
      startWeek: startWeek,
    );
  }

  static _Body body({
    Key key,
    DateTime month,
    DayOfTheWeek startWeek = DayOfTheWeek.Sun,
    Function(DateTime) onSelected,
    double Function(DateTime) onBuildProgressBar,
  }) {
    return _Body(
      key: key,
      month: month,
      startWeek: startWeek,
      onSelected: onSelected,
      onBuildProgressBar: onBuildProgressBar,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _Header(
            largeCircleSize: largeCircleSize,
            smallCircleSize: smallCircleSize,
            largeCircleColor: largeCircleColor,
            smallCircleColor: smallCircleColor,
            largeChild: largeChild,
            smallChild: smallChild,
          ),
          SizedBox(height: 23.0),
          _WeekHeader(
            weekdayColor: weekdayColor,
            weekendColor: weekendColor,
            startWeek: startWeek,
          ),
          _Body(
            startWeek: startWeek,
            onSelected: onSelected,
            onBuildProgressBar: onBuildProgressBar,
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  _Header({
    Key key,
    this.largeCircleSize = _kHeaderLargeCircleSize,
    this.smallCircleSize = _kHeaderSmallCircleSize,
    this.largeCircleColor,
    this.smallCircleColor,
    this.largeChild,
    this.smallChild,
  })  : assert(largeCircleSize != null && largeCircleSize > 0.0),
        assert(smallCircleSize != null && smallCircleSize > 0.0),
        assert(largeCircleSize > smallCircleSize),
        super(key: key);

  final double largeCircleSize;
  final double smallCircleSize;
  final Color largeCircleColor;
  final Color smallCircleColor;
  final Widget largeChild;
  final Widget smallChild;

  double get _verticalSpace =>
      (largeCircleSize - smallCircleSize) * _kHeaderCircleVerticalSpaceRatio;
  double get _horizontalSpace =>
      (largeCircleSize - smallCircleSize) * _kHeaderCircleHorizontalSpaceRatio;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        overflow: Overflow.visible,
        children: [
          // Large circle
          Container(
            width: largeCircleSize,
            height: largeCircleSize,
            decoration: BoxDecoration(
              color: largeCircleColor ?? Get.theme.accentColor,
              shape: BoxShape.circle,
            ),
          ),
          // Small circle
          Positioned(
            top: _verticalSpace,
            left: _horizontalSpace,
            child: Container(
              width: smallCircleSize,
              height: smallCircleSize,
              decoration: BoxDecoration(
                color: smallCircleColor ?? Get.theme.primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: _verticalSpace,
            left: _horizontalSpace,
            child: Container(
              width: smallCircleSize,
              height: smallCircleSize,
              decoration: BoxDecoration(
                color: Get.theme.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: smallChild ?? Container(),
              ),
            ),
          ),
          Container(
            width: largeCircleSize,
            height: largeCircleSize,
            child: Center(
              child: largeChild ?? Container(),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekHeader extends StatelessWidget {
  _WeekHeader({
    Key key,
    this.weekdayColor,
    this.weekendColor,
    this.startWeek = DayOfTheWeek.Sun,
  })  : assert(startWeek != null),
        super(key: key);

  final Color weekdayColor;
  final Color weekendColor;
  final DayOfTheWeek startWeek;

  final _today = DateTime.now();

  Color get _weekdayColor => weekdayColor ?? Get.theme.accentColor;
  Color get _weekendColor => weekendColor ?? Get.theme.primaryColor;

  Widget _buildWeek(DayOfTheWeek dayOfTheWeek) {
    Color backgroundColor;
    TextStyle textStyle = Get.textTheme.bodyText2;
    double height = _kWeekNormalHeight;
    double elevation = 0.0;

    if (_today.weekday - 1 == dayOfTheWeek.index) {
      textStyle = Get.textTheme.bodyText2.copyWith(
        fontWeight: FontWeight.bold,
      );
      height = _kWeekTodayHeight;
      elevation = _kWeekTodayElevation;
    }

    switch (dayOfTheWeek) {
      case DayOfTheWeek.Sat:
      case DayOfTheWeek.Sun:
        backgroundColor = _weekendColor;
        break;
      default:
        backgroundColor = _weekdayColor;
    }

    return Expanded(
      child: Material(
        color: backgroundColor,
        elevation: elevation,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(Constants.smallBorderRadius),
          topRight: Radius.circular(Constants.smallBorderRadius),
        ),
        child: SizedBox(
          height: height,
          child: Center(
            child: AutoColoredWidget(
              backgroundColor: backgroundColor,
              child: Text(
                Utils.getWeekStringEn(dayOfTheWeek),
                style: textStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: List.generate(
          7,
          (index) {
            int weekDay = index + startWeek.index;
            if (weekDay > 6) {
              weekDay -= 7;
            }

            return _buildWeek(DayOfTheWeek.values[weekDay]);
          },
        ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  _Body({
    Key key,
    this.month,
    this.startWeek = DayOfTheWeek.Sun,
    this.onSelected,
    @required this.onBuildProgressBar,
  })  : assert(startWeek != null),
        assert(onBuildProgressBar != null),
        super(key: key);

  final DateTime month;
  final DayOfTheWeek startWeek;
  final Function(DateTime) onSelected;
  final double Function(DateTime) onBuildProgressBar;

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  DateTime selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  Widget _buildCalendar(DateTime month) {
    month = DateTime(month.year, month.month);

    List<Widget> weeks = List<Widget>();
    final DateTime startDate = month
        .subtract(Duration(days: month.weekday - 1 - widget.startWeek.index));

    List<DateTime> temp = List<DateTime>();

    for (int i = 0; i < 42; i++) {
      temp.add(startDate.add(Duration(days: i)));
      if ((i + 1) % 7 == 0) {
        weeks.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: temp
                .map(
                  (e) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 4.0,
                      ),
                      child: _DateTile<DateTime>(
                        date: e,
                        currentMonth: month,
                        value: e,
                        groupValue: selectedDate,
                        onTap: () {
                          setState(() {
                            selectedDate = e;
                          });
                          if (widget.onSelected != null) widget.onSelected(e);
                        },
                        onBuildProgressBar: widget.onBuildProgressBar,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        );
        temp = List<DateTime>();
      }
    }

    return Column(
      children: weeks,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: _buildCalendar(_zeroDate(widget.month ?? DateTime.now())),
    );
  }
}

class _DateTile<T> extends StatelessWidget {
  _DateTile({
    Key key,
    @required this.date,
    @required this.currentMonth,
    this.value,
    this.groupValue,
    this.normalBackgroundColor,
    this.selectedBackgroundColor,
    this.todayBackgroundColor,
    this.onTap,
    @required this.onBuildProgressBar,
  })  : assert(date != null),
        assert(currentMonth != null),
        assert(onBuildProgressBar != null),
        super(key: key);

  final DateTime date;
  final DateTime currentMonth;
  final T value;
  final T groupValue;

  final Color normalBackgroundColor;
  final Color selectedBackgroundColor;
  final Color todayBackgroundColor;

  final Function() onTap;
  final double Function(T) onBuildProgressBar;

  bool get _isSelected => value == groupValue;
  bool get _isToday =>
      _zeroDate(date).isAtSameMomentAs(_zeroDate(DateTime.now()));
  bool get _isBeforeOrEqualToday =>
      _zeroDate(date).isBefore(_zeroDate(DateTime.now())) ||
      _zeroDate(date).isAtSameMomentAs(_zeroDate(DateTime.now()));

  TextStyle get style => currentMonth.month == date.month
      ? Get.textTheme.bodyText1
      : Get.textTheme.bodyText1.copyWith(color: Color(Constants.accentGrey));

  Color get _normalBackgroundColor => normalBackgroundColor ?? Colors.white;
  Color get _selectedBackgroundColor =>
      selectedBackgroundColor ?? Get.theme.accentColor;
  Color get _todayBackgroundColor => todayBackgroundColor ?? Color(0xffc9dcff);
  Color get _backgroundColor {
    if (_isSelected) return _selectedBackgroundColor;

    if (_isToday) return _todayBackgroundColor;

    return _normalBackgroundColor;
  }

  Widget get _bottom {
    if (_isSelected)
      return AutoColoredWidget(
        backgroundColor: _backgroundColor,
        child: Text(
          'select',
          style: TextStyle(
            fontSize: 10.0,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
        ),
      );
    else if (_isBeforeOrEqualToday) {
      final result = onBuildProgressBar(value);
      if (result != null && result >= 0.0) {
        return ProgressBar(
          width: 30.0,
          height: 5.0,
          percentage: result,
          backgroundColor:
              _isToday ? Colors.white : Color(Constants.accentGrey),
        );
      }
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: _kDateTileHeight,
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(Constants.smallBorderRadius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: AutoColoredWidget(
                backgroundColor: _backgroundColor,
                darkColor: style.color,
                child: Text(
                  date.day.toString(),
                  style: style,
                  maxLines: 1,
                ),
              ),
            ),
            _bottom,
          ],
        ),
      ),
    );
  }
}
