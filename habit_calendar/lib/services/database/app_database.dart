import 'package:habit_calendar/services/database/daos/event_dao.dart';
import 'package:habit_calendar/services/database/daos/group_dao.dart';
import 'package:habit_calendar/services/database/daos/index_group_dao.dart';
import 'package:habit_calendar/services/database/daos/notification_type_dao.dart';
import 'package:habit_calendar/services/database/daos/habit_dao.dart';
import 'package:habit_calendar/services/database/daos/habit_week_dao.dart';
import 'package:habit_calendar/services/database/daos/week_dao.dart';
import 'package:habit_calendar/services/database/tables/events.dart';
import 'package:habit_calendar/services/database/tables/groups.dart';
import 'package:habit_calendar/services/database/tables/habits.dart';
import 'package:habit_calendar/services/database/tables/habit_weeks.dart';
import 'package:habit_calendar/services/database/tables/index_groups.dart';
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
    IndexGroups,
  ],
  daos: [
    GroupDao,
    NotificationTypeDao,
    WeekDao,
    HabitDao,
    HabitWeekDao,
    EventDao,
    IndexGroupDao,
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
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          print('beforeOpen() called');

          // Enable foregin key
          await customStatement('PRAGMA foreign_keys = ON');

          if (details.wasCreated) {
            // Insert default group value
            await into(groups)
                .insert(Group(id: 0, name: 'default', color: 0xffffff));
            await into(indexGroups).insert(IndexGroup(groupId: 0, indx: 0));
            // Insert default notification type value
            await into(notificationTypes)
                .insert(NotificationType(id: 0, type: 'none'));
            await into(notificationTypes)
                .insert(NotificationType(id: 1, type: 'alarm'));
            await into(notificationTypes)
                .insert(NotificationType(id: 2, type: 'push'));
            await into(notificationTypes)
                .insert(NotificationType(id: 3, type: 'sns'));
            // Insert default week value
            await into(weeks).insert(Week(id: 0, week: 'mon'));
            await into(weeks).insert(Week(id: 1, week: 'tue'));
            await into(weeks).insert(Week(id: 2, week: 'wed'));
            await into(weeks).insert(Week(id: 3, week: 'thu'));
            await into(weeks).insert(Week(id: 4, week: 'fri'));
            await into(weeks).insert(Week(id: 5, week: 'sat'));
            await into(weeks).insert(Week(id: 6, week: 'sun'));
          }

          // Print inserted values from groups, notification_types, weeks
          print('<groups>');
          (await select(groups).get()).forEach((element) => print(element));
          print('<index_groups>');
          (await select(groups).get()).forEach((element) => print(element));
          print('<notification_types>');
          (await select(notificationTypes).get())
              .forEach((element) => print(element));
          print('<weeks>');
          (await select(weeks).get()).forEach((element) => print(element));
          print('<habits>');
          (await select(habits).get()).forEach((element) => print(element));
          print('<habit_weeks>');
          (await select(habitWeeks).get()).forEach((element) => print(element));
          print('<events>');
          (await select(events).get()).forEach((element) => print(element));

          print('beforeOpen() finished');
        },
      );
}
