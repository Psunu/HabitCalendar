import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/services/database/tables/habit_notice_times.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'habit_notice_time_dao.g.dart';

@UseDao(tables: [HabitNoticeTimes])
class HabitNoticeTimeDao extends DatabaseAccessor<AppDatabase>
    with _$HabitNoticeTimeDaoMixin {
  final AppDatabase db;

  // Called by the AppDatabase class
  HabitNoticeTimeDao(this.db) : super(db);

  Future<List<HabitNoticeTime>> getAllHabitNoticeTimes() =>
      select(habitNoticeTimes).get();
  Stream<List<HabitNoticeTime>> watchAllHabitNoticeTimes() =>
      select(habitNoticeTimes).watch();
  Stream<List<HabitNoticeTime>> watchHabitNoticeTimesByHabitId(int habitId) {
    return (select(habitNoticeTimes)
          ..where((tbl) => tbl.habitId.equals(habitId)))
        .watch();
  }

  Future<int> insertHabitNoticeTime(HabitNoticeTime habitNoticeTime) =>
      into(habitNoticeTimes).insert(habitNoticeTime);

  Future<List<int>> insertAllHabitNoticeTimes(
      List<HabitNoticeTime> noticeTimes) {
    return transaction(() async {
      List<int> result = List<int>();

      for (final habitNoticeTime in noticeTimes) {
        final int id = await into(habitNoticeTimes).insert(habitNoticeTime);
        result.add(id);
      }

      return result;
    });
  }

  Future<bool> updateHabitNoticeTime(HabitNoticeTime habitNoticeTime) =>
      update(habitNoticeTimes).replace(habitNoticeTime);
  Future<int> deleteHabitNoticeTime(HabitNoticeTime habitNoticeTime) =>
      delete(habitNoticeTimes).delete(habitNoticeTime);
}
