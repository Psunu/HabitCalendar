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
  // TODO implement this function
  Stream<List<Habit>> watchHabitsByWeek(DayOfTheWeek dayOfTheWeek) {
    return (select(habits)
          ..orderBy(
            ([
              // Primary sorting by due date
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
            leftOuterJoin(habitWeeks, habitWeeks.habitId.equalsExp(habits.id)),
          ],
        )
        // watch the whole select statement including the join
        .watch()
        // Watching a join gets us a Stream of List<TypedResult>
        // Mapping each List<TypedResult> emitted by the Stream to a List<TaskWithTag>
        .map(
          (rows) => rows.map(
            (row) {
              if (row.readTable(habitWeeks).week == dayOfTheWeek.index)
                return row.readTable(habits);
            },
          ).toList(),
        );
  }

  Future insertHabit(Habit habit) => into(habits).insert(habit);
  Future updateHabit(Habit habit) => update(habits).replace(habit);
  Future deleteHabit(Habit habit) => delete(habits).delete(habit);
}
