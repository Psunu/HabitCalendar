// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:habit_calendar/classes/dao.dart';
// import 'package:habit_calendar/models/group.dart';
// import 'package:habit_calendar/models/notification_type.dart';
// import 'package:habit_calendar/services/database/event_dao.dart';
// import 'package:habit_calendar/services/database/group_dao.dart';
// import 'package:habit_calendar/services/database/habit_dao.dart';
// import 'package:habit_calendar/services/database/habits_week_dao.dart';
// import 'package:habit_calendar/services/database/notification_type_dao.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:get/get.dart';

// class DbService extends GetxService {
//   Database _database;
//   Database get database => _database;
//   List<Dao> _daos = List<Dao>();

//   Future<DbService> init() async {
//     WidgetsFlutterBinding.ensureInitialized();

//     _database = await openDatabase(
//       join(await getDatabasesPath(), 'habit_calendar_database.db'),
//       version: 1,
//       onCreate: (db, version) async {
//         initDaos(db);
//         await db.execute('''
//           PRAGMA foreign_keys = ON;
//         ''');
//         _daos.forEach((element) async => await element.createTable());
//         getDao<GroupDao>().insert(Group(1, 'Default', Colors.white));
//         getDao<NotificationTypeDao>().insert(NotificationType(0, 'PUSH'));
//       },
//     );
//     initDaos(_database);

//     return this;
//   }

//   void initDaos(Database database) {
//     if (_daos.isEmpty) {
//       _daos.add(GroupDao(database));
//       _daos.add(NotificationTypeDao(database));
//       _daos.add(HabitDao(database));
//       _daos.add(HabitsWeekDao(database));
//       _daos.add(EventDao(database));
//     }
//   }

//   T getDao<T>() {
//     T result;
//     _daos.forEach((element) {
//       if (element is T) result = element as T;
//     });

//     return result;
//   }
// }
