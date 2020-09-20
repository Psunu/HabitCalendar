import 'package:habit_calendar/services/database/app_database.dart';
import 'package:habit_calendar/services/database/tables/weeks.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'week_dao.g.dart';

@UseDao(tables: [Weeks])
class WeekDao extends DatabaseAccessor<AppDatabase> with _$WeekDaoMixin {
  final AppDatabase db;

  // Called by the AppDatabase class
  WeekDao(this.db) : super(db);

  Future<List<Week>> getAllWeeks() => select(weeks).get();
  Stream<List<Week>> watchAllWeeks() => select(weeks).watch();
  Future insertWeek(Week week) => into(weeks).insert(week);
  Future updateWeek(Week week) => update(weeks).replace(week);
  Future deleteWeek(Week week) => delete(weeks).delete(week);
}
