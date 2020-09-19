import 'package:habit_calendar/enums/day_of_the_week.dart';

class HabitsWeek {
  int habitId;
  DayOfTheWeek week;

  HabitsWeek(this.habitId, this.week);

  static final tableName = 'habits_week';
  static final columnHabitId = 'habit_id';
  static final columnWeek = 'week';

  HabitsWeek.fromJson(Map<String, dynamic> json)
      : habitId = json[columnHabitId],
        week = DayOfTheWeek.values[json[columnWeek] - 1];

  Map<String, dynamic> toJson() => {
        columnHabitId: habitId,
        columnWeek: week.index + 1,
      };

  String toString() => '$columnHabitId: $habitId, $columnWeek: $week';
}
