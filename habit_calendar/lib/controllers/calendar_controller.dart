import 'package:get/get.dart';
import 'package:habit_calendar/enums/day_of_the_week.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/services/database/db_service.dart';

const _kDateTileAxisFactor = 0.4;

class CalendarController extends GetxController {
  final _dbService = Get.find<DbService>();
  final habits = List<Habit>().obs;
  final events = List<Event>().obs;

  final selectedDate = DateTime.now().obs;
  final today = DateTime.now();
  DayOfTheWeek startWeek = DayOfTheWeek.Sun;

  DateTime get selectedMonth => _zeroMonth(selectedDate.value);

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
    selectedDate.value = _zeroDay(DateTime.now());

    super.onInit();
  }

  DateTime _zeroMonth(DateTime date) => DateTime(date.year, date.month);
  DateTime _zeroDay(DateTime date) => DateTime(date.year, date.month, date.day);

  void onSelected(DateTime date) {
    selectedDate.value = date;
  }

  double onBuildProgressBar(DateTime date) {
    return 0.5;
  }
}
