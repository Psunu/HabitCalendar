// import 'package:habit_calendar/classes/dao.dart';
// import 'package:habit_calendar/models/habit.dart';
// import 'package:habit_calendar/models/habits_week.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:get/get.dart';

// class HabitsWeekDao extends Dao {
//   //Stream<List<Group>> liveGroups;
//   var habitsWeeks = List<HabitsWeek>().obs;
//   ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.replace;

//   HabitsWeekDao(Database database, {this.conflictAlgorithm}) : super(database);

//   @override
//   Future<void> createTable() async {
//     super.database.execute('''
//       CREATE TABLE IF NOT EXISTS ${HabitsWeek.tableName} (
//         ${HabitsWeek.columnHabitId} INTEGER,
//         ${HabitsWeek.columnWeek} INTEGER,
//         FOREIGN KEY (${HabitsWeek.columnHabitId}) REFERENCES habits (${Habit.columnId}) ON UPDATE CASCADE ON DELETE CASCADE
//       );
//     ''');
//   }

//   Future<List<HabitsWeek>> getAll() async {
//     final List<Map<String, dynamic>> maps =
//         await super.database.query(HabitsWeek.tableName);
//     habitsWeeks =
//         List.generate(maps.length, (i) => HabitsWeek.fromJson(maps[i]));
//     return habitsWeeks;
//   }

//   Future<List<HabitsWeek>> getHabitsWeekByHabitId(int habitId) async {
//     final maps = await super.database.query(HabitsWeek.tableName,
//         where: '${HabitsWeek.columnHabitId} = ?', whereArgs: [habitId]);
//     return List.generate(maps.length, (i) => HabitsWeek.fromJson(maps[i]));
//   }

//   Future<void> insert(HabitsWeek habitsWeek) async {
//     await super.database.insert(HabitsWeek.tableName, habitsWeek.toJson());
//   }
// }
