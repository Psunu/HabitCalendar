import 'package:habit_calendar/enums/day_of_the_week.dart';
import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/services/database/tables/habit_weeks.dart';
import 'package:habit_calendar/services/database/tables/habits.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'habit_dao.g.dart';

class HabitWithHabitWeek {
  Habit habit;
  HabitWeek habitWeek;
  HabitWithHabitWeek(this.habit, this.habitWeek);
}

@UseDao(tables: [Habits, HabitWeeks])
class HabitDao extends DatabaseAccessor<AppDatabase> with _$HabitDaoMixin {
  final AppDatabase db;

  // Called by the AppDatabase class
  HabitDao(this.db) : super(db);

  Future<List<Habit>> getAllHabits() => select(habits).get();
  Stream<List<Habit>> watchAllHabits() => select(habits).watch();
  Stream<List<Habit>> watchHabitsByGroupId(int groupId) =>
      (select(habits)..where((tbl) => tbl.groupId.equals(groupId))).watch();
  Stream<List<Habit>> watchHabitsByWeek(DayOfTheWeek dayOfTheWeek) {
    return (select(habits)
          ..orderBy(
            ([
              // Primary sorting by date
              (t) =>
                  OrderingTerm(expression: t.whatTime, mode: OrderingMode.asc),
              // Secondary alphabetical sorting
              (t) => OrderingTerm(expression: t.name),
            ]),
          ))
        // As opposed to orderBy or where, join returns a value. This is what we want to watch/get.
        .join(
          [
            // Join all the tasks with their tags.
            // It's important that we use equalsExp and not just equals.
            // This way, we can join using all tag names in the tasks table, not just a specific one.
            innerJoin(
                habitWeeks,
                habitWeeks.habitId.equalsExp(habits.id) &
                    habitWeeks.week.equals(dayOfTheWeek.index)),
          ],
        )
        // watch the whole select statement including the join
        .watch()
        // Watching a join gets us a Stream of List<TypedResult>
        // Mapping each List<TypedResult> emitted by the Stream to a List<Habit>
        .map(
          (rows) => rows
              .map(
                (row) => row.readTable(habits),
              )
              .toList(),
        );
  }

  Future<int> insertHabit(Habit habit) => into(habits).insert(habit);
  Future<bool> updateHabit(Habit habit) => update(habits).replace(habit);
  Future<int> deleteHabit(Habit habit) => delete(habits).delete(habit);
  Future<int> deleteHabitById(int id) =>
      (delete(habits)..where((tbl) => tbl.id.equals(id))).go();
}
