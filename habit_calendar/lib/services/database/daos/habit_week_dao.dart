import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/services/database/tables/habit_weeks.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'habit_week_dao.g.dart';

@UseDao(tables: [HabitWeeks])
class HabitWeekDao extends DatabaseAccessor<AppDatabase>
    with _$HabitWeekDaoMixin {
  final AppDatabase db;

  // Called by the AppDatabase class
  HabitWeekDao(this.db) : super(db);

  Future<List<HabitWeek>> getAllHabitWeeks() => select(habitWeeks).get();
  Stream<List<HabitWeek>> watchAllHabitWeeks() => select(habitWeeks).watch();
  Future insertHabitWeek(HabitWeek habitWeek) =>
      into(habitWeeks).insert(habitWeek);

  Future<List<int>> insertAllHabitWeeks(List<HabitWeek> weeks) {
    return transaction(() async {
      List<int> result = List<int>();

      for (final week in weeks) {
        final int id = await into(habitWeeks).insert(week);
        result.add(id);
      }

      return result;
    });
  }

  Future updateHabitWeek(HabitWeek habitWeek) =>
      update(habitWeeks).replace(habitWeek);
  Future deleteHabitWeek(HabitWeek habitWeek) =>
      delete(habitWeeks).delete(habitWeek);
}
