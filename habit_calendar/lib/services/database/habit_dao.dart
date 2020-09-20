// import 'package:habit_calendar/classes/dao.dart';
// import 'package:habit_calendar/models/habit.dart';
// import 'package:habit_calendar/models/group.dart';
// import 'package:habit_calendar/models/habits_week.dart';
// import 'package:habit_calendar/services/database/database.dart';
// import 'package:habit_calendar/services/database/habits_week_dao.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:get/get.dart';

// class HabitDao extends Dao<Habit> {
//   //Stream<List<Habit>> liveHabits;
//   //var habits = List<Habit>().obs;
//   ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.replace;

//   HabitsWeekDao get _habitsWeekDao =>
//       Get.find<DbService>().getDao<HabitsWeekDao>();

//   HabitDao(Database database, {this.conflictAlgorithm}) : super(database);

//   @override
//   Future<void> createTable() async {
//     super.database.execute('''
//       CREATE TABLE IF NOT EXISTS ${Habit.tableName} (
//         ${Habit.columnId} INTEGER PRIMARY KEY,
//         ${Habit.columnName} TEXT NOT NULL,
//         ${Habit.columnDescription} TEXT,
//         ${Habit.columnWhatTime} TEXT,
//         ${Habit.columnNotificationTime} INTEGER,
//         ${Habit.columnStatusBarFix} INTEGER NOT NULL DEFAULT 0,
//         ${Habit.columnGroupId} INTEGER NOT NULL DEFAULT 0,
//         ${Habit.columnNotificationTypeId} INTEGER NOT NULL DEFAULT 0,
//         FOREIGN KEY (${Habit.columnGroupId}) REFERENCES groups (${Group.columnId}) ON UPDATE CASCADE ON DELETE SET DEFAULT,
//         FOREIGN KEY (${Habit.columnNotificationTypeId}) REFERENCES notification_type (id) ON update CASCADE ON delete set DEFAULT
//       );
//     ''');
//   }

//   Future<RxList<Habit>> getAll() async {
//     final List<Map<String, dynamic>> maps =
//         await super.database.query(Habit.tableName);
//     observable.update((value) {
//       value = List.generate(maps.length, (i) => Habit.fromJson(maps[i]));
//     });

//     observable.forEach((habit) async {
//       await _injectWeek(habit);
//     });

//     return observable;
//   }

//   Future<Habit> getHabitById(int id) async {
//     final maps = await super.database.query(Habit.tableName,
//         where: '${Habit.columnId} = ?', whereArgs: [id]);
//     if (maps.isEmpty)
//       return null;
//     else {
//       Habit habit = Habit.fromJson(maps[0]);
//       return await _injectWeek(habit);
//     }
//   }

//   Future<Habit> _injectWeek(Habit habit) async {
//     final weeks = await _habitsWeekDao.getHabitsWeekByHabitId(habit.id);
//     habit.weekFromJsons(List.generate(weeks.length, (i) => weeks[i].toJson()));
//     return habit;
//   }

//   Future<void> insert(Habit habit) async {
//     await super.database.insert(
//           Habit.tableName,
//           habit.toJson(),
//           conflictAlgorithm: conflictAlgorithm,
//         );

//     habit.week.forEach((element) async {
//       await _habitsWeekDao.insert(HabitsWeek(habit.id, element));
//     });

//     Habit data = await getHabitById(habit.id);
//     onUpdateOrInsert(data, (i) => observable[i].id == habit.id);
//   }

//   Future<void> update(Habit habit) async {
//     await super.database.update(Habit.tableName, habit.toJson(),
//         where: '${Habit.columnId} = ?', whereArgs: [habit.id]);

//     Habit data = await getHabitById(habit.id);
//     onUpdateOrInsert(data, (i) => observable[i].id == habit.id);
//   }

//   Future<void> delete(Habit habit) async {
//     await super.database.delete(Habit.tableName,
//         where: '${Habit.columnId} == ?', whereArgs: [habit.id]);
//     onDelete(habit, (index) => observable[index].id == habit.id);
//   }
// }
