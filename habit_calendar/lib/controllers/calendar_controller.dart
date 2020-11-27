import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:habit_calendar/constants/constants.dart';
import 'package:habit_calendar/enums/day_of_the_week.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/services/database/db_service.dart';
import 'package:habit_calendar/utils/utils.dart';

const _kDateTileAxisFactor = 0.4;

class CalendarController extends GetxController {
  CalendarController({
    PageController fullCalendarPageController,
    PageController weekCalendarPageController,
  })  : fullCalendarPageController =
            fullCalendarPageController ?? PageController(initialPage: 1000),
        weekCalendarPageController =
            weekCalendarPageController ?? PageController(initialPage: 1000);

  final _dbService = Get.find<DbService>();
  final habits = List<Habit>().obs;
  final events = List<Event>().obs;

  final _duration = const Duration(
    milliseconds: Constants.mediumAnimationSpeed,
  );
  final _curve = Curves.ease;

  PageController fullCalendarPageController;
  PageController weekCalendarPageController;

  final selectedDate = DateTime.now().obs;
  DateTime _today = DateTime.now();
  DayOfTheWeek startWeek = DayOfTheWeek.Sun;

  DateTime get selectedMonth => selectedDate.value.zeroMonth();
  DateTime get today => _today;

  double get calendarAxisAlignment {
    final week = ((selectedMonth.weekday -
                1 -
                startWeek.index +
                selectedDate.value.day) /
            7.1)
        .floor();

    return -1.0 + _kDateTileAxisFactor * week;
  }

  @override
  void onInit() {
    habits.bindStream(_dbService.database.habitDao
        .watchHabitsByWeek(DayOfTheWeek.values[today.weekday - 1]));
    events.bindStream(_dbService.database.eventDao.watchAllEvents());

    _today = DateTime.now().zeroDay();
    selectedDate.value = _today;

    super.onInit();
  }

  DateTime _subtractMonth(DateTime date, int subtraction) {
    DateTime result = date.zeroMonth();

    for (int i = 0; i < subtraction; i++) {
      result = (result.subtract(const Duration(days: 15))).zeroMonth();
    }

    return result;
  }

  DateTime _addMonth(DateTime date, int add) {
    DateTime result = date.zeroMonth();

    for (int i = 0; i < add; i++) {
      result = (result.add(const Duration(days: 40))).zeroMonth();
    }

    return result;
  }

  DateTime _subtractWeek(DateTime date, int subtraction) {
    DateTime result = date.firstDayOfWeek(startWeek: startWeek);

    for (int i = 0; i < subtraction; i++) {
      result = (result.subtract(const Duration(days: 7))).zeroDay();
    }

    return result;
  }

  DateTime _addWeek(DateTime date, int add) {
    DateTime result = date.firstDayOfWeek(startWeek: startWeek);

    for (int i = 0; i < add; i++) {
      result = (result.add(const Duration(days: 7))).zeroDay();
    }

    return result;
  }

  DateTime getMonthByFullCalendarIndex(int index) {
    final offset = index - fullCalendarPageController.initialPage;

    if (offset < 0) {
      return _subtractMonth(today, offset.abs());
    }

    return _addMonth(today, offset);
  }

  DateTime getWeekByWeekCalendarIndex(int index) {
    final offset = index - weekCalendarPageController.initialPage;

    if (offset < 0) {
      return _subtractWeek(today, offset.abs());
    } else {
      return _addWeek(today, offset.abs());
    }

    return selectedDate.value;
  }

  void onFullCalendarPageChanged(int index) {
    final offset = index - fullCalendarPageController.initialPage;

    if (getMonthByFullCalendarIndex(index).month != selectedMonth.month) {
      if (offset == 0) {
        selectedDate.value = today;
      } else if (offset < 0) {
        selectedDate.value = _subtractMonth(today, offset.abs());
      } else {
        selectedDate.value = _addMonth(today, offset);
      }
    }
  }

  void onWeekCalendarPageChanged(int index) {
    final offset = index - weekCalendarPageController.initialPage;

    if (offset == 0) {
      selectedDate.value = today;
    } else if (offset < 0) {
      selectedDate.value = _subtractWeek(today, offset.abs());
    } else {
      selectedDate.value = _addWeek(today, offset.abs());
    }
  }

  void refreshHabits() {
    habits.bindStream(_dbService.database.habitDao.watchHabitsByWeek(
        DayOfTheWeek.values[selectedDate.value.weekday - 1]));
  }

  void onSelectedInFullCalendar(DateTime date) {
    if (date.month != selectedMonth.month) {
      if (date.isBefore(selectedDate.value))
        fullCalendarPageController.previousPage(
          duration: _duration,
          curve: _curve,
        );
      else if (date.isAfter(selectedDate.value)) {
        fullCalendarPageController.nextPage(
          duration: _duration,
          curve: _curve,
        );
      }
    }

    selectedDate.value = date;
    refreshHabits();
  }

  void onSelectedInWeekCalendar(DateTime date) {
    selectedDate.value = date;
    refreshHabits();
  }

  double onBuildProgressBar(DateTime date) {
    return 0.5;
  }
}
