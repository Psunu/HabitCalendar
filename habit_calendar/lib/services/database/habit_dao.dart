import 'package:habit_calendar/classes/dao.dart';
import 'package:habit_calendar/models/habit.dart';
import 'package:sqflite/sqflite.dart';
import 'package:get/get.dart';

class HabitDao extends Dao {
  Stream<List<Habit>> liveHabits;
  var habits = List<Habit>().obs;
  ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.replace;

  HabitDao(Database database, {this.conflictAlgorithm}) : super(database);

  @override
  Future<void> createTable() async {
    super.database.execute('''
      CREATE TABLE IF NOT EXISTS habits (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        what_time TEXT,
        notification_time INTEGER,
        status_bar_fix INTEGER NOT NULL DEFAULT 0,
        group_id INTEGER NOT NULL DEFAULT 0,
        notification_type_id INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (group_id) REFERENCES groups (id) ON UPDATE CASCADE ON DELETE SET DEFAULT,
        FOREIGN KEY (notification_type_id) REFERENCES notification_type (id) ON update CASCADE ON delete set DEFAULT
      );

      CREATE TABLE IF NOT EXISTS habits_week (
        habit_id INTEGER,
        week INTEGER,
        FOREIGN KEY (habit_id) REFERENCES habits (id) ON UPDATE CASCADE ON DELETE CASCADE
      );
    ''');
  }

  Future<List<Habit>> getAll() async {
    final List<Map<String, dynamic>> maps =
        await super.database.query('habits');
    habits = List.generate(maps.length, (i) => Habit.fromJson(maps[i]));
    return habits;
  }
}
