import 'package:habit_calendar/services/database/daos/event_dao.dart';
import 'package:habit_calendar/services/database/daos/group_dao.dart';
import 'package:habit_calendar/services/database/daos/notification_type_dao.dart';
import 'package:habit_calendar/services/database/daos/habit_dao.dart';
import 'package:habit_calendar/services/database/daos/habit_week_dao.dart';
import 'package:habit_calendar/services/database/daos/week_dao.dart';
import 'package:habit_calendar/services/database/tables/events.dart';
import 'package:habit_calendar/services/database/tables/groups.dart';
import 'package:habit_calendar/services/database/tables/habits.dart';
import 'package:habit_calendar/services/database/tables/habit_weeks.dart';
import 'package:habit_calendar/services/database/tables/notification_types.dart';
import 'package:habit_calendar/services/database/tables/weeks.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'app_database.g.dart';

@UseMoor(
  tables: [
    Groups,
    NotificationTypes,
    Weeks,
    Habits,
    HabitWeeks,
    Events,
  ],
  daos: [
    GroupDao,
    NotificationTypeDao,
    WeekDao,
    HabitDao,
    HabitWeekDao,
    EventDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      // Specify the location of the database file
      : super((FlutterQueryExecutor.inDatabaseFolder(
          path: 'db.sqlite',
          // Good for debugging - prints SQL in the console
          logStatements: true,
        )));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration =>
      MigrationStrategy(beforeOpen: (details) async {
        customStatement('PRAGMA foreign_keys = ON');
        GroupsCompanion.insert(
            id: const Value(0), name: 'default', color: 0xffffff);
        NotificationTypesCompanion.insert(id: const Value(0), type: 'PUSH');
        NotificationTypesCompanion.insert(id: const Value(1), type: 'ALARM');
        WeeksCompanion.insert(id: const Value(0), week: 'mon');
        WeeksCompanion.insert(id: const Value(1), week: 'tue');
        WeeksCompanion.insert(id: const Value(2), week: 'wed');
        WeeksCompanion.insert(id: const Value(3), week: 'thu');
        WeeksCompanion.insert(id: const Value(4), week: 'fri');
        WeeksCompanion.insert(id: const Value(5), week: 'sat');
        WeeksCompanion.insert(id: const Value(6), week: 'sun');
      });
}
